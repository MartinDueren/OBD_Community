class Measurement < ActiveRecord::Base
  #set_rgeo_factory_for_column(:latlon,
  #RGeo::Geographic.spherical_factory(:srid => 4326))  
  belongs_to :trip
  #after_create :getFuelConsumption
  
  #validates_presence_of :trip_id
  attr_accessible :trip_id, :maf, :consumption, :co2, :lon, :lat, :rpm, :speed, :measurements_attributes, :latlon, :recorded_at, :map, :iat, :imap, :ve, :ed

  set_rgeo_factory_for_column(:latlon,
    RGeo::Geographic.spherical_factory(:srid => 4326))



  def getFuelConsumption

  end

  def getCO2Emission

  end
  
end
