# This migration comes from community_engine (originally 33)
class FeaturedUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :featured_writer, :boolean, :default => false
  end

  def self.down
    remove_column :users, :featured_writer
  end
end
