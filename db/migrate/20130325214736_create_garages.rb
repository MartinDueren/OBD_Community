class CreateGarages < ActiveRecord::Migration
  def change
    create_table :garages do |t|

      t.timestamps
    end
  end
end
