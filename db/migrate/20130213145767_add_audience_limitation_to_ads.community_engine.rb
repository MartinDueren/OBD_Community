# This migration comes from community_engine (originally 51)
class AddAudienceLimitationToAds < ActiveRecord::Migration
  def self.up
    add_column :ads, :audience, :string, :default => 'all'
  end

  def self.down
    remove_column :ads, :audience
  end
end
