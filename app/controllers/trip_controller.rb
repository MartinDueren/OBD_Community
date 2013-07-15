class TripController < BaseController

  before_filter :track_action

  before_filter :login_required, :only => [:show]
  before_filter :login_with_access_token, :only => [:create]
  
  before_filter :require_group_1, :only => [:show_single_trip]
  before_filter :require_group_1, :only => [:show]
  before_filter :require_group_1_or_2, :only => [:compare]
  before_filter :require_group_4, :only => [:show_abstract_trip]
  before_filter :require_group_4, :only => [:abstract]

  uses_tiny_mce do
    {:only => [:show], :options => configatron.default_mce_options}
  end

  def show
    if params.has_key?(:user)
      @trips = User.find_by_id(params[:user]).trips.scoped.page(params[:page]).per(5).order('created_at DESC')
    else
      @trips = current_user.trips.scoped.page(params[:page]).per(5).order('created_at DESC')
    end
    @action = "trip_" + action_name
    render :layout => "trips"
  end

  def abstract
    if params.has_key?(:user)
      @trips = User.find_by_id(params[:user]).trips.scoped.page(params[:page]).per(5).order('created_at DESC')
    else
      @trips = current_user.trips.scoped.page(params[:page]).per(5).order('created_at DESC')
    end
    render :layout => "trips"
  end

  def compare
    @action = action_name
    @tripA = Trip.find_by_id(params[:a])
    @tripB = Trip.find_by_id(params[:b])
    gon.measurementsMap1 = @tripA.measurements.order("recorded_at ASC")
    gon.measurementsMap2 = @tripB.measurements.order("recorded_at ASC")
    render :layout => "trips"
  end
  
  #used for ..\show\trip\:id
  def show_single_trip
    @action = action_name
    if params.has_key?(:id)
      @trip = Trip.find_by_id(params[:id])
      gon.measurements = @trip.measurements.order("recorded_at ASC")
      gon.statistics = {"max_speed" => @trip.measurements.maximum(:speed), "max_rpm" => @trip.measurements.maximum(:rpm), "max_consumption" => @trip.measurements.maximum(:consumption)}
      render :layout => "trips"
    end
  end
  
  def show_abstract_trip
    @action = action_name
    if params.has_key?(:id)
      @trip = Trip.find_by_id(params[:id])
      gon.measurements = @trip.measurements
      gon.statistics = {"max_speed" => @trip.measurements.maximum(:speed), "max_rpm" => @trip.measurements.maximum(:rpm), "max_consumption" => @trip.measurements.maximum(:consumption)}
      render :layout => "trips"
    end
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

    wgs84_proj4 = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'


    wgs84_factory = RGeo::Cartesian.factory(:srid => 4326)
    factory_merc = RGeo::Geographic.simple_mercator_factory
    
    factory = RGeo::Geographic.projected_factory(:projection_proj4 => '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs')

    #debugger
    unless params[:import].nil?
      @trip.user_id = current_user.id


      measurements = []
      params[:features].each { |feature| 
        coords = wgs84_factory.point(feature[:geometry][:coordinates][0],feature[:geometry][:coordinates][1])

        measurements << Measurement.new(
          "recorded_at" => feature[:properties][:time],
          "speed" => feature[:properties][:phenomenons][:Speed][:value],
          "rpm" => feature[:properties][:phenomenons][:Rpm][:value],
          "maf" => feature[:properties][:phenomenons][:MAF][:value],
          "iat" => feature[:properties][:phenomenons][:'Intake Temperature'][:value],
          "map" => feature[:properties][:phenomenons][:'Intake Pressure'][:value],
          "consumption" => feature[:properties][:phenomenons][:Consumption][:value],
          "co2" => feature[:properties][:phenomenons][:CO2][:value],
          "latlon" => coords,
          )
      }

      measurements.sort! { |a,b| a.recorded_at <=> b.recorded_at }
      debugger
      measurements.each do  |m|
        @trip.measurements.new(
          "recorded_at" => m.recorded_at,
          "speed" => m.speed,
          "rpm" => m.rpm,
          "maf" => m.maf,
          "iat" => m.iat,
          "map" => m.map,
          "consumption" => m.consumption,
          "co2" => m.co2,
          "latlon" => m.latlon
          )
      end
      debugger

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
    
    @trip.delay.integrateTrip
    #@trip.integrateTrip
  end

  private
    def track_action
      Analytics.new(:user_id => current_user.id, :action => action_name, :url => "/trip/#{action_name}/", :description => params.to_json, :group => current_user.group, :category => "").save
    end

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

    def require_group_1
      unless current_user.group == 1
        redirect_to login_url
      end
    end
    def require_group_1_or_2
      unless current_user.group == 1 || current_user.group == 2
        redirect_to login_url
      end
    end
    def require_group_4
      unless current_user.group == 4
        redirect_to login_path
      end
    end
end