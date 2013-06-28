class AddStatisticsToUser < ActiveRecord::Migration
  def change
    add_column :users, :rpm, :float, :default => 0
    add_column :users, :speed, :float, :default => 0
    add_column :users, :standingtime, :float, :default => 0
    add_column :users, :consumption, :float, :default => 0
  end
end
