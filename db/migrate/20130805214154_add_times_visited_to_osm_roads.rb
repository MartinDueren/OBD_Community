class AddTimesVisitedToOsmRoads < ActiveRecord::Migration
  def change
    add_column :osm_roads, :times_visited, :integer, :default => 0
  end
end
