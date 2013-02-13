# This migration comes from community_engine (originally 30)
class AddUsersCounterCache < ActiveRecord::Migration
  def self.up
    add_column :metro_areas, :users_count, :integer, :default => 0
  end

  def self.down
    remove_column :metro_areas, :users_count
  end
end
