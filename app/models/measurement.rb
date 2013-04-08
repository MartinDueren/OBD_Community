class Measurement < ActiveRecord::Base
  
  belongs_to :trip
  
  validates_presence_of :trip_id
  attr_accessible :trip_id, :lon, :lat, :rpm, :speed
  
  def geojson
    filename = File.join(Rails.root, 'db', 'development.sqlite3')
    db = SQLite3::Database.new(filename)
    sql = "SELECT created_at, trip_id, lon, lat, rpm, speed FROM measurements Order BY created_at ASC;"

    coordinates = []
    db.execute(sql) do |row|
      coordinates << [ row[2],row[3] ]
    end

    # return a GeoJSON 'FeatureCollection' 
    { :type => "FeatureCollection",
      :features => [
        :type => "Feature",
        :geometry => {
          :type => "GeometryCollection",
          :geometries => [
            { :type => "LineString", :coordinates => coordinates }
          ]
        }
      ]
    }
  end
  
end
