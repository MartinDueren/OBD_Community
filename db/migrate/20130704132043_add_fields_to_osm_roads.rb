class AddFieldsToOsmRoads < ActiveRecord::Migration
  def change
    add_column :osm_roads, :measurement_count, :int, :default => 0
    add_column :osm_roads, :avg_speed, :int, :default => 0
    add_column :osm_roads, :avg_rpm, :int, :default => 0
    add_column :osm_roads, :avg_co2, :float, :default => 0
    add_column :osm_roads, :avg_consumption, :float, :default => 0
    add_column :osm_roads, :max_speed, :int, :default => 0
    add_column :osm_roads, :avg_standing_time, :int, :default => 0
    add_column :osm_roads, :geom, :geometry
    add_column :osm_roads, :highway, :text
    
    add_index(:osm_roads, :geom, :spatial => true)  # spatial index
  end
end