# This migration comes from community_engine (originally 18)
class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :categories
  end
end
