class AddMeasurementCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :measurement_count, :int, :default => 0
  end
end
