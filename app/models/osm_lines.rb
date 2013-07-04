class OsmLines < ActiveRecord::Base
  attr_accessible :measurement_count, :avg_speed, :avg_rpm, :avg_co2, :avg_consumption, :max_speed, :avg_standing_time

end
