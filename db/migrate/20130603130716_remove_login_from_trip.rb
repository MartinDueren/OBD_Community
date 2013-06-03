class RemoveLoginFromTrip < ActiveRecord::Migration
  def up
  	remove_column :trips, :login
  end

  def down
  	add_column :trips, :login, :string
  end
end
