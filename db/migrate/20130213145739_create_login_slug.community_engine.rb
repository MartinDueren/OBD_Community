# This migration comes from community_engine (originally 20)
class CreateLoginSlug < ActiveRecord::Migration
  def self.up
    add_column "users", "login_slug", :string
  end

  def self.down
    remove_column "users", "login_slug"
  end
end
