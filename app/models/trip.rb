class Trip < ActiveRecord::Base  
  acts_as_commentable
  
  belongs_to :user
  has_many   :measurements, :foreign_key => 'trip_id' 
  
  attr_accessible :login, :measurements_attributes
  accepts_nested_attributes_for :measurements

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
  
end
