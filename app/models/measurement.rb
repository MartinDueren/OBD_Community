class Measurement < ActiveRecord::Base
  set_rgeo_factory_for_column(:latlon,
  RGeo::Geographic.spherical_factory(:srid => 4326))  
  belongs_to :trip
  
  #validates_presence_of :trip_id
  attr_accessible :trip_id, :maf, :consumption, :co2, :lon, :lat, :rpm, :speed, :measurements_attributes, :latlon, :recorded_at, :map, :iat, :imap, :ve, :ed

  def getFuelConsumption
  	#self.imap = self.rpm * self.map / self.iat
  	#self.maf = (self.imap / 120.0) * (85.0 / 100.0) * 1.2 * 28.97 / 8.314
    235.214 / (710.7 * self.speed / self.maf) #Old method: ((14.7 * 6.17 * 454 * (self.speed*0.621371)) / (3600 * self.maf))
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
