class AddRecordedAtToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :recorded_at, :datetime
  end
end
