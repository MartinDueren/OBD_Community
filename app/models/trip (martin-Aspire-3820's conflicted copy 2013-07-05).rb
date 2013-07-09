class Trip < ActiveRecord::Base  
  acts_as_commentable
  
  belongs_to :user
  has_many   :measurements, :foreign_key => 'trip_id' 
  
  attr_accessible :login, :measurements_attributes
  accepts_nested_attributes_for :measurements

  serialize :badges,Array


  def getTripLength
  	@trip_length = 0
   	for i in 1..(self.measurements.length-1)
		 	@trip_length += self.measurements[i-1].latlon.distance(self.measurements[i].latlon)
  	end
  	#Convert to km and round to two decimal places
    @trip_length = @trip_length/1000
  	('%.2f' % @trip_length).to_f
  end

  def getTripCo2

  end

  def getAvgConsumption
    sum = 0
    self.measurements.each do |m|
      if m.speed == 0
        sum = sum + 0.5
      else
        sum = sum + m.getFuelConsumption
      end
    end
    '%.2f' % (sum / self.measurements.length)
  end
  
  def next
    Trip.where("id > ?", id).order("id ASC").first
  end

  def prev
    Trip.where("id < ?", id).order("id DESC").first
  end

  #Check for badges and calc all relevant statistics
  def integrateTrip

    #remove standing time from beginning and end
    for i in (self.measurements.length-1).downto(0)
      if self.measurements[i].speed == 0
        self.measurements[i].delete
      else
        break
      end
    end

    for i in 0..self.measurements.length-1
      if self.measurements[i].speed == 0
        self.measurements[i].delete
      else
        break
      end
    end
    ################

    @tripAttrs = {:length => 0, :rpmAbove2500 => 0, :rpmAbove3000 => 0, :standingTime => 0, :braking => 0, :acceleration => 0}
    @tripAttrs[:length] = self.getTripLength
    @current_user = User.find_by_id(self.user_id)

    self.measurements.each_with_index do |m, i|
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
      if m.speed < self.measurements[i-1].speed
        @diff = self.measurements[i-1].speed - m.speed
        @tripAttrs[:braking] += (@tripAttrs[:braking] + @diff) / 2
      end
      #acceleration
      if m.speed > self.measurements[i-1].speed
        @diff =  m.speed - self.measurements[i-1].speed
        @tripAttrs[:acceleration] += (@tripAttrs[:acceleration] + @diff) / 2
      end
    end


    #### Check for individual badges
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

    @current_user.update_attributes(:measurement_count => (@current_user.measurement_count + self.measurements.length))

    #### find nearest street for every measurement and calculate stats 
    r = OsmRoads.find_by_sql("SELECT DISTINCT ON (pt_id) pt_id, ln_id, ST_AsText(ST_line_interpolate_point(ln