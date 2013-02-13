# This migration comes from community_engine (originally 62)
class AddNotifyToComments < ActiveRecord::Migration
  
  def self.up
    add_column :comments, :notify_by_email, :boolean, :default => true
  end
  
  def self.down
    remove_column :comments, :notify_by_email
  end

end
