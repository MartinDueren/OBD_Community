class AddHasSnapshotToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :has_snapshot, :boolean, :default => false
  end
end
