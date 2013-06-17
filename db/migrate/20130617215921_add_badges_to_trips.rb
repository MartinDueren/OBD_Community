class AddBadgesToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :badges, :text
  end
end
