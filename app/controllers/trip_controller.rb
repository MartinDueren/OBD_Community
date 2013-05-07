class TripController < BaseController

  before_filter :login_required, :only => [:show]
  before_filter :login_with_access_token, :only => [:create]

  uses_tiny_mce do
    {:only => [:show], :options => configatron.default_mce_options}
  end

  def show
    if params.has_key?(:id)
      gon.measurements = Measurement.where("trip_id = ?", params[:id])
      render :layout => "trips"
    else
      #If this isn't in a thread the server stalls'
      thread = Thread.new{
        @user = current_user.login
        @trips = Trip.where("login = ?", @user)

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
      render :layout => "trips"
    end
  end
  
  def show_single_trip
    @action = action_name
    if params.has_key?(:id)
      gon.measurements = Measurement.where("trip_id = ?", params[:id])
      render :layout => "trips"
    end
  end

  #used for making a map snapshot
  def show_static_trip
    if params.has_key?(:id)
      @tripId = params[:id]
      @measurements = Measurement.where("trip_id = ?",  @tripId)
      gon.tripId = @tripId
      gon.measurements = @measurements
      puts(@tripId)
    end
    render :layout => "trip_static"
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
