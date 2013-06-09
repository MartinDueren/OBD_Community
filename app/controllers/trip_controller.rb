class TripController < BaseController
  before_filter :login_required, :only => [:show]
  before_filter :login_with_access_token, :only => [:create]
  
  uses_tiny_mce do
    {:only => [:show], :options => configatron.default_mce_options}
  end

  def show
    #If this isn't in a thread the server stalls'
    thread = Thread.new{
      @trips = current_user.trips

      @trips.each { |x|
        if !FileTest.exist?("./public/assets/trips/#{x.id}.png")
          system(
          "/usr/bin/phantomjs " +
          "./app/assets/javascripts/phantom_snapshot.js " +
          "http://localhost:3000/trip/show_static_trip?id=#{x.id} " +
          "./public/assets/trips/#{x.id}.png '#map'&"
          )
        end
      }
    }
    thread.join
    @trips = current_user.trips.scoped.page(params[:page]).per(5)
    render :layout => "trips"
  end
  
  #used for ..\show\trip\:id
  def show_single_trip
    @action = action_name
    if params.has_key?(:id)
      gon.measurements = Trip.find_by_id(params[:id]).measurements
      render :layout => "trips"
    end
  end
  
  def abstract
    #@action = action_name
    #Do calcs here and provide numbers
  end

  #used for making a map snapshot
  def show_static_trip
    if params.has_key?(:id)
      gon.measurements = Trip.find_by_id(params[:id]).measurements# @tripMeasurement.where("trip_id = ?",  @tripId)
    end
    render :layout => "trip_static"
  end


  def create

    unless params[:import].nil?
      @trip = Trip.new
      @trip.save
      @trip.user_id = current_user.id

      params[:features].each { |feature| 
        @trip.measurements.new(
          "recorded_at" => Time.parse(feature[:properties][:time]),
          "speed" => feature[:properties][:phenomenons][:Speed][:value],
          "lat" => feature[:geometry][:coordinates][0],
          "lon" => feature[:geometry][:coordinates][1],
          "trip_id" => @trip.id
          )
      }

      respond_to do |format|
        if @trip.save
          format.html { redirect_to @trip, notice: 'Trip successfully created.' }
          format.json { render json: @trip, status: :created}
        else
          format.html { render :layout => "trips" }
          format.json { render json: @trip.errors, status: :unprocessable_entity }
        end
      end


    else
      #create empty trip to get an id to pass on to measurements
      @trip = Trip.new
      @trip.save
      trip_id = @trip.id

      #create real trip from json here
      @trip = Trip.new(params[:trip])
      @trip.user_id = current_user.id
      #change trip_id in measurements
      @trip.measurements.each { |x|
        x.trip_id = trip_id
      }
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
  end

  private
  def login_with_access_token
    if params[:token].nil?
      access_denied
    else
      user = User.find_by_single_access_token(params[:token])
      if user.nil?
        access_denied
      else
        UserSession.create(user) if(user.present?)
      end
    end
  end
end
