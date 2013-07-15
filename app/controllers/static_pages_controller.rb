class StaticPagesController < BaseController
  
  #before_filter force_ssl, :only => [:auth]
  before_filter :require_group_2, :only => [:community_map]
  before_filter :require_group_3, :only => [:badges]
  before_filter :require_group_3, :only => [:scoreboard]

  def community_map
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
    @measurements = Measurement.where(:trip_id => Trip.where("user_id = ?", current_user.id).select(:id).pluck(:id))
    @badgesList = Hash.new(0)
    current_user.badges.each do |v|
      @badgesList[v.id] += 1
    end
    render :layout => "trips"
  end

  def scoreboard
    #All Measurements, now do something with it!
    @measurements = Measurement.all
    render :layout => "trips"
  end
  
  def landing
    #if logged_in?
      #redirect_to "#{config.root}/trip/show"
    #else
    render :layout => "landing"
    #end
  end
  
  private
    def require_group_2
      unless current_user.group == 2
        redirect_to login_url
      end
    end
    def require_group_3
      unless current_user.group == 3
        redirect_to login_url
      end
    end
end
