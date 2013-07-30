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
    avg = 0
    self.measurements.each do |m|
      avg += m.consumption / m.speed
    end
    avg / self.measurements.length
  end

  def getTotalConsumption
    sum = 0
    self.measurements.each_with_index do |m,i|
      speed = 1
      if m.speed > 0 
        speed = m.speed
      end
      unless i == 0
        seconds = m.recorded_at - self.measurements[i-1].recorded_at
        sum += seconds * (m.consumption / speed) 
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
    measurements = self.measurements.order("recorded_at ASC")

    #remove standing time from beginning and end
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
    ################

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
      if self.getTripLength > 1
        firstTrip
        km
        co2
        fuelConsumption
        shifting
        goodRoute
        smoothBraking
        smoothAcceleration
        consecutiveTrips
        firstFriend
        firstComment
        gotComment
        mostMiles
      end

      self.save

      #### Grant Badges
      self.badges.each do |badge|
        User.find_by_id(self.user_id).add_badge(badge[0].id)
        User.find_by_id(self.user_id).add_points(badge[0].custom_fields[:points], "#{badge[0].custom_fields[:points]} Points granted #{badge[0].description}")
      end
      
      #update user statistics
      div = self.measurements.length + @current_user.measurement_count
      @current_user.update_attributes(:mileage => (@current_user.mileage + @tripAttrs[:length].to_i))
      @current_user.update_attributes(:rpm => (((@current_user.rpm * @current_user.measurement_count) + (self.measurements.average(:rpm).to_f * self.measurements.length)) / div))
      @current_user.update_attributes(:speed => (((@current_user.speed * @current_user.measurement_count) + (self.measurements.average(:speed).to_f * self.measurements.length)) / div))
      @current_user.update_attributes(:consumption => (((@current_user.consumption * @current_user.measurement_count) + (self.measurements.average(:consumption).to_f * self.measurements.length)) / div))
      @current_user.update_attributes(:standingtime => (@current_user.standingtime + (self.measurements.where(:speed => 0).count * 5)))
      @current_user.update_attributes(:co2 => (((@current_user.co2 * @current_user.measurement_count) + (self.measurements.average(:co2).to_f * self.measurements.length)) / div))
      @current_user.update_attributes(:total_co2 => (@current_user.total_co2 + (self.getTotalCo2 / 1000)))
      @current_user.update_attributes(:total_consumption => (@current_user.total_consumption + (self.getTotalConsumption / 1000)))
      @current_user.update_attributes(:measurement_count => (@current_user.measurement_count + self.measurements.length))

      #### find nearest street for every measurement and calculate stats 
      res = OsmRoads.find_by_sql("SELECT DISTINCT ON (pt_id) pt_id, ln_id, ST_AsText(ST_line_interpolate_point(ln_geom, ST_line_locate_point(ln_geom, pt_geom))) FROM (SELECT ln.geom AS ln_geom, pt.latlon AS pt_geom, ln.id AS ln_id, pt.id AS pt_id, ST_Distance(ln.geom, pt.latlon) AS d FROM (SELECT * FROM measurements WHERE trip_id = #{self.id}) pt, osm_roads ln WHERE ST_DWithin(pt.latlon, ln.geom, 10.0) ORDER BY pt_id,d ) AS subquery;")

      res.each do |m|
        osm_road = OsmRoads.find_by_id(m.ln_id)
        nm = Measurement.find_by_id(m.pt_id)
        div = osm_road.measurement_count + 1

        if nm.speed > osm_road.max_speed
          osm_road.update_attributes(:max_speed => nm.speed)
        end

        osm_road.update_attributes(:avg_speed => (((osm_road.avg_speed * osm_road.measurement_count) + nm.speed) / div))
        osm_road.update_attributes(:avg_rpm => (((osm_road.avg_rpm * osm_road.measurement_count) + nm.rpm) / div))
        osm_road.update_attributes(:avg_consumption => (((osm_road.avg_consumption * osm_road.measurement_count) + nm.consumption) / div))
        osm_road.update_attributes(:avg_standing_time => (((osm_road.avg_standing_time * osm_road.measurement_count) + 5) / div))
        osm_road.update_attributes(:avg_co2 => (((osm_road.avg_co2 * osm_road.measurement_count) + nm.co2) / div))

        osm_road.update_attributes(:measurement_count => osm_road.measurement_count + 1)
      end
    end
  end


  def firstTrip
    if User.find_by_id(self.user_id).trips.length == 1
      self.badges << [Merit::Badge.get(1), self.id]
    end
  end

  def km
    mileage = 0
    User.find_by_id(self.user_id).trips.each { |t|
      mileage += t.getTripLength.to_f
    }
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(2) and mileage >= 50 
      self.badges << [Merit::Badge.get(2), self.id]  
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(3) and mileage >= 100 
      self.badges << [Merit::Badge.get(3), self.id]
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(4) and mileage >= 500 
      self.badges << [Merit::Badge.get(4), self.id]
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(5) and mileage >= 1000 
      self.badges << [Merit::Badge.get(5), self.id]
    end
  end

  def co2
    #TODO add co2Avg field to user, should be corrected on every trip create
  end

  def fuelConsumption
    #TODO add fuelConsumtion field to user, should be corrected on every trip create
  end

  def shifting
    #if less than 1% of measurements is below 2500/3000 rpm
    if @tripAttrs[:rpmAbove2500] <= 1*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(13), self.id]
    elsif @tripAttrs[:rpmAbove3000] <= 1*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(12), self.id]
    end
  end

  def goodRoute
    if @tripAttrs[:standingTime] <= 10*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(14), self.id]
    end
  end

  def smoothBraking
    #if less than 2% of brakings were less than 30 km/h diff between measurements
    if @tripAttrs[:braking] <= 2*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(15), self.id]
    end
  end

  def smoothAcceleration
    #if less than 2% of brakings were less than 30 km/h diff between measurements
    if @tripAttrs[:braking] <= 2*(self.measurements.length/100)
      self.badges << [Merit::Badge.get(16), self.id]
    end
  end

  def sharedTrip
    #TODO
  end

  #TODO test if works
  def consecutiveTrips
    @consecutive = 1
    if User.find_by_id(self.user_id).trips.length > 1
      while self.prev.created_at.beginning_of_day == self.created_at.yesterday.beginning_of_day
        @consecutive += 1
      end
    end
    case @consecutive
    when 2
      self.badges << [Merit::Badge.get(18), self.id]
    when 3
      self.badges << [Merit::Badge.get(19), self.id]
    when 4
      self.badges << [Merit::Badge.get(20), self.id]
    when 5
      self.badges << [Merit::Badge.get(21), self.id]
    when 6
      self.badges << [Merit::Badge.get(22), self.id]
    when 7
      self.badges << [Merit::Badge.get(23), self.id]
    end
  end

  def firstFriend
    #TODO
  end

  def firstComment
    #TODO
  end

  def gotComment
    #TODO
  end

  def testUser
    User.find_by_id(self.user_id).add_badge(27)
  end

  def mostMiles
    #TODO
  end

end
