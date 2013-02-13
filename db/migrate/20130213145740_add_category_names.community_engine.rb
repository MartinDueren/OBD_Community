# This migration comes from community_engine (originally 21)
class AddCategoryNames < ActiveRecord::Migration
  def self.up
    # Deprecated: add categories by logging in as admin and going to /categories
  end

  def self.down
  end
end
