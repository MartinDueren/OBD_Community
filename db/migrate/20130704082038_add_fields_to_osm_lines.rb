class AddFieldsToOsmLines < ActiveRecord::Migration
  def change
    add_column :osm_lines, :measurement_count, :int, :default => 0
    add_column :osm_lines, :avg_speed, :int, :default => 0
    add_column :osm_lines, :avg_rpm, :int, :default => 0
    add_column :osm_lines, :avg_co2, :float, :default => 0
    add_column :osm_lines, :avg_consumption, :float, :default => 0
    add_column :osm_lines, :max_speed, :int, :default => 0
    add_column :osm_lines, :avg_standing_time, :int, :default => 0
  end
end
