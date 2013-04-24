class ChangeLoginToString < ActiveRecord::Migration
  def up
    change_column :trips, :login, :string
  end

  def down
    change_column :trips, :login, :integer
  end
end
