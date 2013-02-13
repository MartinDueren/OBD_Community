# This migration comes from community_engine (originally 34)
class AddLastLogin < ActiveRecord::Migration
  def self.up
    add_column :users, :last_login_at, :datetime
  end

  def self.down
    remove_column :users, :last_login_at
  end
end
