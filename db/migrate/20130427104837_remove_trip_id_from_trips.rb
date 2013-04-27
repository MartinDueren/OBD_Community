class RemoveTripIdFromTrips < ActiveRecord::Migration
  def up
    remove_column :trips, :trip_id
  end

  def down
    add_column :trips, :trip_id, :integer
  end
end
