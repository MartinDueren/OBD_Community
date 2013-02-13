# This migration comes from community_engine (originally 68)
class CreateRsvps < ActiveRecord::Migration
  def self.up
    create_table :rsvps do |t|
      t.belongs_to :user, :event
      t.integer :attendees_count
      t.timestamps
    end
  end

  def self.down
    drop_table :rsvps
  end
end
