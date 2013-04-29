class StaticPagesController < BaseController
 
  before_filter force_ssl, :only => [:auth]
  
  def community_map
    @measurements = Measurement.all
    gon.measurements = @measurements
    render :layout => "fullmap"
  end
  
  def auth
    authenticate_or_request_with_http_basic do |username, password|
      if user = User.find_by_login(username)
        response.headers['Auth'] = 'Password incorrect'
        if user.valid_password?(password)
          response.headers['Auth'] = 'Credentials correct'
          response.headers['Token'] = user.single_access_token
        end
      else
        response.headers['Auth'] = 'Username incorrect'
        false
      end
    end
  end
  
  def help
  end
  
  def badges
    #All Measurements of that user, now do something with it!
    @measurements = Measurement.where(:trip_id => Trip.where("login = ?", "Martin").select(:id).pluck(:id))
    render :layout => "trips"
  end

  def scoreboard
    #All Measurements, now do something with it!
    @measurements = Measurement.all
    render :layout => "trips"
  end
  
  def landing
    render :layout => "landing"
  end
end
