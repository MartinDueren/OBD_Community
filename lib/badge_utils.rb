module BadgeUtils
  debugger
  @tripAttrs = {:length => self.getTripLength, :rpmAbove2500 => 0, :rpmAbove3000 => 0, :standingTime => 0, :braking => 0, :acceleration => 0}


  def checkTripForBadges
  	#remove standing time from beginning and end
    until self.measurements.last.speed != 0
      self.measurements.last.destroy
    end

    until self.measurements.first.speed != 0
      self.measurements.first.destroy
    end

    self.measurements.each_with_index do |m, i|
  		if m.rpm >= 2500
  			@tripAttrs[:rpmAbove2500] += 1
  		end

  		if m.rpm >= 3000
  			@tripAttrs[:rpmAbove3000] += 1
  		end

      if m.speed = 0
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

    debugger

  	firstTrip
  	km
    shifting
    goodRoute
    smoothBraking
    smoothAcceleration
    consecutiveTrips
  end

  def firstTrip
  	if current_user.trips.length == 1
  		current_user.add_badge(1)
  	end
  end

  def km
  	@mileage = 0
  	current_user.trips.each { |t|
  		mileage += t.getTripLength
  	}

  	if !current_user.badges.include? Merit::Badge.find(2) && mileage >= 50 
  		current_user.add_badge(2)
  	end
  	if !current_user.badges.include? Merit::Badge.find(3) && mileage >= 100 
  		current_user.add_badge(3)
  	end
  	if !current_user.badges.include? Merit::Badge.find(4) && mileage >= 500 
  		current_user.add_badge(4)
  	end
  	if !current_user.badges.include? Merit::Badge.find(5) && mileage >= 1000 
  		current_user.add_badge(5)
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
      current_user.add_badge(13)
    elsif @tripAttrs[:rpmAbove3000] <= 2*self.measurements.length/100
      current_user.add_badge(12)
    end
  end

  def goodRoute
    if @tripAttrs[:standingTime] <= 10*self.measurements.length/100
      current_user.add_badge(14)
    end
  end

  def smoothBraking
    if @tripAttrs[:braking] >= 20
      current_user.add_badge(15)
    end
  end

  def smoothAcceleration
    if @tripAttrs[:braking] >= 20
      current_user.add_badge(16)
    end
  end

  def sharedTrip
    #TODO
  end

  def consecutiveTrips
    @consecutive = 1
    while self.prev.created_at.beginning_of_day == self.created_at.yesterday.beginning_of_day
      @consecutive += 1
    end
    case @consecutive
    when 2
      current_user.add_badge(18)
    when 3
      current_user.add_badge(19)
    when 4
      current_user.add_badge(20)
    when 5
      current_user.add_badge(21)
    when 6
      current_user.add_badge(22)
    when 7
      current_user.add_badge(23)
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
    current_user.add_badge(27)
  end

  def mostMiles
    #TODO
  end
end