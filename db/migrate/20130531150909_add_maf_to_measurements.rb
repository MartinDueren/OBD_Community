class AddMafToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :maf, :float
  end
end
