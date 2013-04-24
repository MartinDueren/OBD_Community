class ChangeTripIdtoInteger < ActiveRecord::Migration
  def up
    connection.execute(%q{
    alter table trips
    alter column trip_id
    type integer using cast(trip_id as integer)
    })
    
    connection.execute(%q{
    alter table measurements
    alter column trip_id
    type integer using cast(trip_id as integer)
    })
  end

  def down
    change_column :trips, :trip_id, :string
    change_column :measurements, :trip_id, :string
  end
end
