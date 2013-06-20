class Measurement < ActiveRecord::Base
	set_rgeo_factory_for_column(:latlon,
    RGeo::Geographic.spherical_factory(:srid => 4326))  
  belongs_to :trip
  
  validates_presence_of :trip_id
  attr_accessible :trip_id, :lon, :lat, :rpm, :speed, :measurements_attributes, :latlon, :recorded_at, :map, :iat, :imap, :ve, :ed

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
