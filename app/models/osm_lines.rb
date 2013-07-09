class OsmLines < ActiveRecord::Base
  attr_accessible :measurement_count, :avg_speed, :avg_rpm, :avg_co2, :avg_consumption, :max_speed, :avg_standing_time, :geom, :highway

  set_rgeo_factory_for_column(:geom,
    RGeo::Geographic.spherical_factory(:srid => 4326))
  
end