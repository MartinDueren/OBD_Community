class Measurement < ActiveRecord::Base
  
  belongs_to :trip
  
  validates_presence_of :trip_id
  attr_accessible :trip_id, :lon, :lat, :rpm, :speed

  def getFuelConsumption
    #TODO make this in l/100km (include speed information) (pay attention
	#to speed=0)

	if self.fuel_type == "Gasoline"
		(self.maf / 14.7) / 747
	elsif self.fuel_type == "Diesel"
		(self.maf / 14.5) / 832
	else
		#TODO throw error
	end
  end

  def getCO2Emission
  	#TODO change unit to kg/km (include speed information) (pay attention
	#to speed=0)

	if self.fuel_type == "Gasoline"
		self.getFuelConsumption * 2.35
	elsif self.fuel_type == "Diesel"
		self.getFuelConsumption * 2.65
	else
		#TODO throw error
	end
  end
  
end
