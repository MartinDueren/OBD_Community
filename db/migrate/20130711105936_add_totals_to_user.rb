class AddTotalsToUser < ActiveRecord::Migration
  def change
    add_column :users, :total_co2, :float, :default => 0
    add_column :users, :total_consumption, :float, :default => 0
    add_column :users, :co2, :float, :default => 0
  end
end
