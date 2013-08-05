class Trip < ActiveRecord::Base  
  acts_as_commentable
  acts_as_taggable

  belongs_to :user
  has_many   :measurements, :foreign_key => 'trip_id' 
  
  attr_accessible :login, :measurements_attributes
  accepts_nested_attributes_for :measurements

  serialize :badges,Array

  after_save do |trip|
    activity = Activity.new(:action => 'Trip', :item_id => trip.id)
  end

  def getTripLength
  	@trip_length = 0
    measurements = self.measurements.order("recorded_at ASC")
   	for i in 1..(measurements.length-1)
		 	@trip_length += measurements[i-1].latlon.distance(measurements[i].latlon)
  	end
  	#Convert to km and round to two decimal places
    @trip_length = @trip_length/1000
  	('%.2f' % @trip_length).to_f
  end

  def getTripCo2
    self.measurements.average(:co2).to_f
  end

  #outputs grams
  def getTotalCo2
    sum = 0
    self.measurements.each_with_index do |m,i|
      unless i == 0
        seconds = m.recorded_at - self.measurements[i-1].recorded_at
        sum += seconds * (m.co2)
      end
    end
    sum
  end

  def getAvgConsumption
    self.measurements.average(:consumption).to_f
  end

  def getTotalConsumption
    sum = 0
    self.measurements.each_with_index do |m,i|
      unless i == 0
        consumption = m.maf / 10731 #to l per s
        seconds = m.recorded_at - self.measurements[i-1].recorded_at
        sum += seconds * consumption 
      end
    end
    sum
  end
  
  def next
    Trip.where("id > ?", id).order("id ASC").first
  end

  def prev
    Trip.where("id < ?", id).order("id DESC").first
  end

  #Check for badges and calc all relevant statistics, watch out for the spaghetti monster!!
  def integrateTrip
    Rails.logger.info "Integrating trip"
    measurements = self.measurements.order("recorded_at ASC")

    #remove standing time from beginning and end
    Rails.logger.info "Removing leading and trailing zeros"
    for i in (measurements.length-1).downto(0)
      if measurements[i].speed == 0
        measurements[i].destroy
      else
        break
      end
    end

    for i in 0..measurements.length-1
      if measurements[i].speed == 0
        measurements[i].destroy
      else
        break
      end
    end


    #if no measurements left, destroy and exit
    if self.measurements.length <= 5
      Rails.logger.info "Destroying trip"
      self.destroy
      return
    end
    ################

    Rails.logger.info "Calculating trip attributes"
    if measurements.length > 0

      @tripAttrs = {:length => 0, :rpmAbove2500 => 0, :rpmAbove3000 => 0, :standingTime => 0, :braking => 0, :acceleration => 0, :measurements => measurements}
      @tripAttrs[:length] = self.getTripLength
      @current_user = User.find_by_id(self.user_id)

      measurements.each_with_index do |m, i|
        if m.rpm >= 2500
          @tripAttrs[:rpmAbove2500] += 1
        end

        if m.rpm >= 3000
          @tripAttrs[:rpmAbove3000] += 1
        end
        
        if m.speed == 0
          @tripAttrs[:standingTime] += 1
        end

        #braking
        if m.speed < measurements[i-1].speed
          @diff = measurements[i-1].speed - m.speed
          if @diff > 30
            @tripAttrs[:braking] += 1
          end
        end
        #acceleration
        if m.speed > measurements[i-1].speed
          @diff =  m.speed - measurements[i-1].speed
          if @diff > 30
            @tripAttrs[:acceleration] += 1
          end
        end
      end


      #### Check for individual badges if trip longer than 1 km
      Rails.logger.info "Checking for individual Badges"
      Rails.logger.info "self.length=" + self.getTripLength.to_s
      Rails.logger.info "Trip.length=" + Trip.find_by_id(self.id).getTripLength.to_s
      Rails.logger.info "self.measurements.first.to_json=" + self.measurements.first.to_json
      if self.measurements.length > 10
        firstTrip
        km
        co2
        fuelConsumption
        shifting
        goodRoute
        smoothBraking
        smoothAcceleration
        consecutiveTrips
        mostMiles
      end
      Rails.logger.info self.to_json
      self.save

      #### Grant Badges
      Rails.logger.info "Granting Badges"
      self.badges.each do |badge|
        User.find_by_id(self.user_id).add_badge(badge[0].id)
        User.find_by_id(self.user_id).add_points(badge[0].custom_fields[:points], "#{badge[0].custom_fields[:points]} Points granted #{badge[0].description}")
      end
      

      #### find nearest street for every measurement and calculate stats 
      Rails.logger.info "Finding nearest streets for every measurement and update dataset statistics"
      res = OsmRoads.find_by_sql("SELECT DISTINCT ON (pt_id) pt_id, ln_id, ST_AsText(ST_line_interpolate_point(ln_geom, ST_line_locate_point(ln_geom, pt_geom))) FROM (SELECT ln.geom AS ln_geom, pt.latlon AS pt_geom, ln.id AS ln_id, pt.id AS pt_id, ST_Distance(ln.geom, pt.latlon) AS d FROM (SELECT * FROM measurements WHERE trip_id = #{self.id}) pt, osm_roads ln WHERE ST_DWithin(pt.latlon, ln.geom, 10.0) ORDER BY pt_id,d ) AS subquery;")
      Rails.logger.info "Found " + res.length.to_s + " street segments"
      
      #count measurements with speed == 0 for each matched segment
      count = Hash.new(0)
      res.each do |m|
        if Measurement.find_by_id(m.pt_id).speed == 0
          count[m.ln_id] += 5
        end
      end

      count.each do |m|
        road = OsmRoads.find_by_id(m[0])
        times_visited = road.times_visited
        road_standing_time = road.avg_standing_time
        new_avg = (((road_standing_time * times_visited) + m[1]) / (times_visited + 1))

        road.update_attributes(:avg_standing_time => new_avg)
      end

      res.each do |m|
        Rails.logger.info "Updating element with id " + m.ln_id.to_s
        osm_road = OsmRoads.find_by_id(m.ln_id)
        nm = Measurement.find_by_id(m.pt_id)
        div = osm_road.measurement_count + 1

        if nm.speed > osm_road.max_speed
          osm_road.update_attributes(:max_speed => nm.speed)
        end



        osm_road.update_attributes(:avg_speed => (((osm_road.avg_speed * osm_road.measurement_count) + nm.speed) / div))
        osm_road.update_attributes(:avg_rpm => (((osm_road.avg_rpm * osm_road.measurement_count) + nm.rpm) / div))
        osm_road.update_attributes(:avg_consumption => (((osm_road.avg_consumption * osm_road.measurement_count) + nm.consumption) / div))


        

        
        osm_road.update_attributes(:avg_co2 => (((osm_road.avg_co2 * osm_road.measurement_count) + nm.co2) / div))

        osm_road.update_attributes(:measurement_count => osm_road.measurement_count + 1)
      end
      Rails.logger.info "Integrating trip - done"
    end
  end


  def firstTrip
    if self.id == User.find_by_id(self.user_id).trips.minimum(:id)
      Rails.logger.info "granted first Trip"
      self.badges << [Merit::Badge.get(1), self.id]
    end
  end

  #confirmed working
  def km
   
    mileage = 0
    User.find_by_id(self.user_id).trips.each { |t|
      mileage += t.getTripLength.to_f
    }
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(2) and mileage >= 50 
      self.badges << [Merit::Badge.get(2), self.id]  
       Rails.logger.info "granted 50 km"
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(3) and mileage >= 100 
      self.badges << [Merit::Badge.get(3), self.id]
       Rails.logger.info "granted 100 km"
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(4) and mileage >= 500 
      self.badges << [Merit::Badge.get(4), self.id]
       Rails.logger.info "granted 500 km"
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(5) and mileage >= 1000 
      self.badges << [Merit::Badge.get(5), self.id]
       Rails.logger.info "granted 1000 km"
    end
  end

  #not confirmed working
  def co2
    trip_co2 = self.getTripCo2
    overall_co2 = User.average(:co2)
    
    if trip_co2 < (overall_co2 - ((overall_co2 / 100) * 35))
      self.badges << [Merit::Badge.get(7), self.id]
    elsif trip_co2 < (overall_co2 - ((overall_co2 / 100) * 25))
      self.badges << [Merit::Badge.get(6), self.id]
    end

    min_co2_week = 999
    trips_last_week = Trip.where(:created_at => Time.now.prev_week..Time.now.prev_week.end_of_week)
    trips_last_week.each do |trip|
      if trip.getTripCo2 < min_co2_week && trip != self
        min_co2_week = trip.getTripCo2
      end
    end

    if trip_co2 < min_co2_week
      self.badges << [Merit::Badge.get(8), self.id]
    end
  end

  #not confirmed working
  def fuelConsumption
    trip_consumption = self.getAvgConsumption
    overall_consumption = User.average(:consumption)
    
    if trip_consumption < (overall_consumption - ((overall_consumption / 100) * 35))
      self.badges << [Merit::Badge.get(10), self.id]
    elsif trip_consumption < (overall_consumption - ((overall_consumption / 100) * 25))
      self.badges << [Merit::Badge.get(9), self.id]
    end

    min_consumption_week = 999
    trips_last_week = Trip.where(:created_at => Time.now.prev_week..Time.now.prev_week.end_of_week)
    trips_last_week.each do |trip|
      if trip.getAvgConsumption < min_consumption_week && trip != self
        min_consumption_week = trip.getAvgConsumption
      end
    end

    if trip_consumption < min_consumption_week
      self.badges << [Merit::Badge.get(11), self.id]
    end
  end


  def shifting  
    #if less than 1% of measurements is below 2500/3000 rpm
    if @tripAttrs[:rpmAbove2500] <= 1*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(13), self.id]
      Rails.logger.info "granted good shifting"
    elsif @tripAttrs[:rpmAbove3000] <= 1*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(12), self.id]
      Rails.logger.info "granted awesome shifting"
    end
  end

  def goodRoute
    if @tripAttrs[:standingTime] <= 10*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(14), self.id]
      Rails.logger.info "granted good route"
    end
  end

  def smoothBraking
    #if less than 2% of brakings were less than 30 km/h diff between measurements
    if @tripAttrs[:braking] <= 2*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(15), self.id]
      Rails.logger.info "granted smooth braking"
    end
  end

  def smoothAcceleration
    #if less than 2% of brakings were less than 30 km/h diff between measurements
    if @tripAttrs[:braking] <= 2*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(16), self.id]
      Rails.logger.info "granted acceleration"
    end
  end

  def consecutiveTrips
    user = User.find_by_id(self.user_id)
    user_trips = user.trips.order("created_at DESC")
    consecutive_badges = [Merit::Badge.find(18),Merit::Badge.find(19),Merit::Badge.find(20),Merit::Badge.find(21),Merit::Badge.find(22),Merit::Badge.find(23)]
    self_badges = []
    self.badges.each do |b|
      self_badges << b[0]
    end
    consecutive_badges += self_badges

    user_trips.each do |t|
      if t != self && t.created_at.beginning_of_day == self.created_at.beginning_of_day && consecutive_badges.length != consecutive_badges.uniq.length 
        Rails.logger.info "Exiting consecutive Trips because there was another trip today"
        return
      end
    end

    consecutive = 1
    for i in 0..(user_trips.length-2)
      if i > 6 then
        break
      end
      if user_trips[i+1].created_at.beginning_of_day == user_trips[i].created_at.yesterday.beginning_of_day
        consecutive += 1
      end
    end

    case consecutive
    when 2
      self.badges << [Merit::Badge.get(18), self.id]
      Rails.logger.info "granted consecutive trips"
    when 3
      self.badges << [Merit::Badge.get(19), self.id]
      Rails.logger.info "granted consecutive trips"
    when 4
      self.badges << [Merit::Badge.get(20), self.id]
      Rails.logger.info "granted consecutive trips"
    when 5
      self.badges << [Merit::Badge.get(21), self.id]
      Rails.logger.info "granted consecutive trips"
    when 6
      self.badges << [Merit::Badge.get(22), self.id]
      Rails.logger.info "granted consecutive trips"
    when 7
      self.badges << [Merit::Badge.get(23), self.id]
      Rails.logger.info "granted consecutive trips"
    end
  end

  def mostMiles
    @current_user = User.find_by_id(self.user_id)
    unless @current_user.mileage >= User.maximum(:mileage)
      if (User.mileage + self.getTripLength) > User.maximum(:mileage)
        self.badges << [Merit::Badge.get(28), self.id]
      end
    end
  end

end
