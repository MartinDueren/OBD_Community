class AddLocationToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :latlon, :point, :geographic => true
    remove_column :measurements, :lat
    remove_column :measurements, :lon
  end
end
