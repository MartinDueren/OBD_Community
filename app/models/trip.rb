class Trip < ActiveRecord::Base  
  acts_as_commentable
  
  belongs_to :user
  has_many   :measurements, :foreign_key => 'trip_id' 
  
  attr_accessible :login, :measurements_attributes
  accepts_nested_attributes_for :measurements

  serialize :badges,Array

  def getTripLength
  	@trip_length = 0
  	for i in 1..(User.all[0].trips[0].measurements.length-1)
  		if self.measurements[i-1].class == Measurement && self.measurements[i].class == Measurement
			@trip_length += Geocoder::Calculations.distance_between(
				[self.measurements[i-1].lat,self.measurements[i-1].lon], 
				[self.measurements[i].lat,self.measurements[i].lon], 
				:units => :km)
		end
  	end
  	#Rounding to two decimal places
  	'%.2f' % @trip_length
  end
  
  def next
    Trip.where("id > ?", id).order("id ASC").first
  end

  def prev
    Trip.where("id < ?", id).order("id DESC").first
  end

  
  def checkTripForBadges
    @tripAttrs = {:length => 0, :rpmAbove2500 => 0, :rpmAbove3000 => 0, :standingTime => 0, :braking => 0, :acceleration => 0}

    #debugger
    @tripAttrs[:length] = self.getTripLength
    #debugger
    #remove standing time from beginning and end
    # while self.measurements.last.speed == 0
    #   self.measurements.last.destroy
    #   debugger
    # end
    #debugger
    # while self.measurements.first.speed == 0
    #   self.measurements.first.destroy
      #debugger
    #end
    #debugger
    self.measurements.each_with_index do |m, i|
      # if m.rpm >= 2500
      #   @tripAttrs[:rpmAbove2500] += 1
      # end

      # if m.rpm >= 3000
      #   @tripAttrs[:rpmAbove3000] += 1
      # end
      
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



    firstTrip
    km
    #shifting
    goodRoute
    smoothBraking
    smoothAcceleration
    consecutiveTrips
    self.save
    self.badges.each do |badge|
      User.find_by_id(self.user_id).add_badge(badge[0].id)
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

    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(2) && mileage >= 50 
      self.badges << [Merit::Badge.get(2), self.id]  
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(3) && mileage >= 100 
      self.badges << [Merit::Badge.get(3), self.id]
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(4) && mileage >= 500 
      self.badges << [Merit::Badge.get(4), self.id]
    end
    if !User.find_by_id(self.user_id).badges.include? Merit::Badge.find(5) && mileage >= 1000 
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
    if @tripAttrs[:rpmAbove2500] <= 2*self.measurements.length/100
      self.badges << [Merit::Badge.get(13), self.id]
    elsif @tripAttrs[:rpmAbove3000] <= 2*self.measurements.length/100
      self.badges << [Merit::Badge.get(12), self.id]
    end
  end

  def goodRoute
    if @tripAttrs[:standingTime] <= 10*self.measurements.length/100
      self.badges << [Merit::Badge.get(14), self.id]
    end
  end

  def smoothBraking
    if @tripAttrs[:braking] >= 20
      self.badges << [Merit::Badge.get(15), self.id]
    end
  end

  def smoothAcceleration
    if @tripAttrs[:braking] >= 20
      self.badges << [Merit::Badge.get(16), self.id]
    end
  end

  def sharedTrip
    #TODO
  end

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
