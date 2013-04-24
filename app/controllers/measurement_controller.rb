class MeasurementController < BaseController
  
  def create
  end

  def show
    respond_to do |format|
      #format.html # show.html.erb
      format.json {
        coordinates = []
        Measurement.where("id = ?", params[:id]).each { |x|
          coordinates << [x.lat,x.lon]
        }
        
        # return a GeoJSON 'FeatureCollection'
        render json:
          { :type => "FeatureCollection",
            :features => [
              :type => "Feature",
              :geometry => {
                :type => "Point",
                :coordinates => coordinates[0]
                },
                :properties => {}
              ]
          }
      }
    end
  end
end
