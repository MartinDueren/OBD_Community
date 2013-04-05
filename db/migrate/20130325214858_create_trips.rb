class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      
      t.timestamps
      
      t.column :trip_id,  :string
      t.column :login,    :integer
    end
  end
end
