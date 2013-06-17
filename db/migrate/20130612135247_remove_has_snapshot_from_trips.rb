class RemoveHasSnapshotFromTrips < ActiveRecord::Migration
  def up
  	remove_column :trips, :has_snapshot
  end

  def down
  	add_column :trips, :has_snapshot, :boolean, :default => false
  end
end
