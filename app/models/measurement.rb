class Measurement < ActiveRecord::Base
  
  belongs_to :trip
  
  validates_presence_of :trip_id
  attr_accessible :trip_id, :lon, :lat, :rpm, :speed
  
end
