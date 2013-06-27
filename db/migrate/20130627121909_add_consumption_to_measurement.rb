class AddConsumptionToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :consumption, :float
  end
end
