class TripController < BaseController

  before_filter :login_required, :only => [:show]
  before_filter :login_with_access_token, :only => [:create]

  uses_tiny_mce do
    {:only => [:show], :options => configatron.default_mce_options}
  end

  def show
    @trips = current_user.trips.scoped.page(params[:page]).per(5).order('created_at DESC')
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
  
  def show_abstract_trip
    @trips = current_user.trips.scoped.page(params[:page]).per(5).order('created_at DESC')
    render :layout => "trips"
  end

  #used for making a map snapshot
  def show_static_trip
    if params.has_key?(:id)
      gon.measurements = Trip.find_by_id(params[:id]).measurements# @tripMeasurement.where("trip_id = ?",  @tripId)
    end
    render :layout => "trip_static"
  end


  def create
    #create empty trip to get an id to pass on to measurements
    @trip = Trip.new
    #@trip.save

    unless params[:import].nil?
      @trip.user_id = current_user.id

      params[:features].each { |feature| 
        @trip.measurements.new(
          "recorded_at" => Time.parse(feature[:properties][:time]),
          "speed" => feature[:properties][:phenomenons][:Speed][:value],
          "latlon" => "POINT(#{feature[:geometry][:coordinates][0]} #{feature[:geometry][:coordinates][1]})",
          #"trip_id" => @trip.id
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
      #create real trip from json here
      @trip = Trip.new(params[:trip])
      @trip.user_id = current_user.id
      #change trip_id in measurements
      @trip.measurements.each { |x|
        x.trip_id = @trip.id
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

    @exec = "/usr/bin/phantomjs/bin/phantomjs " +
          "./app/assets/javascripts/phantom_snapshot.js " +
          "http://" + configatron.app_host + "/trip/show_static_trip?id=#{@trip.id} " +
          "./public/assets/trips/#{@trip.id}.png '#map'"
    thread = Thread.new{
      system(@exec)
    }
    thread.join
    
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
