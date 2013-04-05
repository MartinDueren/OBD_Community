class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|

      t.timestamps
      
      t.column :trip_id,    :string
      t.column :lon,        :float
      t.column :lat,        :float
      t.column :rpm,        :integer
      t.column :speed,      :float
    end
  end
end
