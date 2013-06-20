class AddMileageToUser < ActiveRecord::Migration
  def change
    add_column :users, :mileage, :integer, :default => 0
  end
end
