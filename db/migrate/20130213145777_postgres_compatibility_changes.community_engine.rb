# This migration comes from community_engine (originally 61)
class PostgresCompatibilityChanges < ActiveRecord::Migration
  def self.up
    change_column :messages, :recipient_deleted, :boolean, :default => false
  end

  def self.down
    change_column :messages, :recipient_deleted, :boolean, :default => 0
  end
end
