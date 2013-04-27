class TripController < BaseController
  
  before_filter :login_required, :only => [:show]
  before_filter :login_with_access_token, :only => [:create]
  
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
        @user = current_user.login
        @trips = Trip.where("login = ?", @user)
        #debugger
        @trips.each { |x|
          if FileTest.exist?("./public/assets/trips/#{x.id}.png")
            puts("############ /public/assets/trips/#{x.id}.png exists")
            system(
              "/usr/bin/phantomjs " + 
              "./app/assets/javascripts/phantom_snapshot.js " + 
              "http://localhost:3000/trip/show_single_trip?id=#{x.id} " +
              "./public/assets/trips/#{x.id}.png '#map'&"
              )    
          end
        }
        render :layout => "trips"        
      }
    end
  end
  
  def show_single_trip
    if params.has_key?(:id)
      @tripId = params[:id]
      @measurements = Measurement.where("id = ?",  @tripId)
      gon.tripId = @tripId
      gon.measurements = @measurements
      puts(@tripId)
    end
    render :layout => "trip_single"
  end

  
  def create
    @trip = Trip.new(:login => current_user.login)

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip successfully created.' }
        format.json { render json: @trip, status: :created}
      else
        format.html { render :layout => "trips" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private 
    def login_with_access_token
      if params[:token].nil?
        access_denied
      end
      
      user = User.find_by_single_access_token(params[:token])
      if user.nil?
        access_denied
      else
        UserSession.create(user) if(user.present?)
      end
    end
end
