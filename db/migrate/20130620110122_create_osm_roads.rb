class CreateOsmRoads < ActiveRecord::Migration
  def change
    create_table :osm_roads do |t|

      t.timestamps
    end
  end
end
