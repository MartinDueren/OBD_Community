class OsmRoads < ActiveRecord::Base
  # attr_accessible :title, :body
  #set_table_name 'planet_osm_line'
  #set_primary_key 'osm_id'
  set_rgeo_factory_for_column(:geom,
    RGeo::Geographic.spherical_factory(:srid => 4326))
end