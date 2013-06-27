class AddCo2ToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :co2, :float
  end
end
