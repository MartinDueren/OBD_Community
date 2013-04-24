class TripController < BaseController
  
  before_filter :login_required, :only => [:show, :create]

  uses_tiny_mce do
    {:only => [:show], :options => configatron.default_mce_options}
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
      
      format.html {
        @test = 100
        render :layout => "trips"
        system("/usr/bin/phantomjs ./app/assets/javascripts/phantom_snapshot.js http://localhost:3000/trip/show_single_trip?tripId=1 ./app/assets/images/trips/#{@test}.png '#map'&")
        
      }
    end
    
    #wo has_snapshot false ist snapshot machen!!
    #das macht JS, hier nur gon objekte uebergeben
    @user = current_user.login
    @trips = Trip.where("login = ?", @user)
    gon.trips = @trips
    puts('##############################')
    puts(@trips[0].trip_id)
    puts(current_user.login)
    puts('##############################')
    
    
    
    #render :layout => "trips"
  end
  
  def show_single_trip
    if params.has_key?(:tripId)
      @tripId = params[:tripId]
      @measurements = Measurement.where("trip_id = ?",  @tripId)
      gon.tripId = @tripId
      gon.measurements = @measurements
      puts(@tripId)
      #debugger
    end
    #debugger
    render :layout => "trip_single"
  end

  def create
    puts("create")
  end
end
