class AddValuesToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :map, :integer
    add_column :measurements, :iat, :integer
    add_column :measurements, :imap, :float
    add_column :measurements, :ve, :integer
    add_column :measurements, :ed, :integer
  end
end
