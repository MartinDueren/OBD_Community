class AddFuelTypeToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :fuel_type, :string
  end
end
