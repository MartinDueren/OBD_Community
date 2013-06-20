class OsmRoads < ActiveRecord::Base
  # attr_accessible :title, :body
  set_table_name 'planet_osm_roads'
  set_primary_key 'osm_id'
end
