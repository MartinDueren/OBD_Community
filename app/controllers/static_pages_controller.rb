class StaticPagesController < BaseController
  
  #before_filter force_ssl, :only => [:auth]
  before_filter :require_group_2, :only => [:community_map]
  before_filter :require_group_3, :only => [:badges]
  before_filter :require_group_3, :only => [:scoreboard]
  before_filter :track_action

  def community_map
    gon.user = current_user.id
    gon.params = params
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
    gon.user = current_user.id
      gon.params = params
    if current_user.group == 3
      @badgesList = Hash.new(0)
      current_user.badges.each do |v|
        @badgesList[v.id] += 1
      end
      render :layout => "trips"
    else
      redirect_to login_url
    end
  end

  def scoreboard
    gon.user = current_user.id
      gon.params = params
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
    def track_action
      if current_user != nil      
        Analytics.new(:user_id => current_user.id, :action => action_name, :url => "/static_pages/#{action_name}/", :description => params.to_json, :group => current_user.group, :category => "").save
      end
    end

    def require_group_2
      unless current_user.group == 2 || current_user.group == 0
        redirect_to login_url
      end
    end
    def require_group_3
      unless current_user.group == 3 || current_user.group == 0
        redirect_to login_url
      end
    end
end
