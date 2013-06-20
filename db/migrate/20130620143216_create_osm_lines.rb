class CreateOsmLines < ActiveRecord::Migration
  def change
    create_table :osm_lines do |t|

      t.timestamps
    end
  end
end
