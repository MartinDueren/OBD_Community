class AddLocationToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :latlon, :point, :srid => 4326
    add_index(:measurements, :latlon, :spatial => true)  # spatial index
    remove_column :measurements, :lat
    remove_column :measurements, :lon

  end
end
