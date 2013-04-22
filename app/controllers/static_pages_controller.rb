class StaticPagesController < BaseController
 
  def community_map
    render :layout => "fullmap"
  end
  
  def auth
    authenticate_or_request_with_http_basic do |username, password|
      if user = User.find_by_login(username)
        response.headers['Auth'] = 'Password incorrect'
        if user.valid_password?(password)
          response.headers['Auth'] = 'Credentials correct'
        end
      else
        response.headers['Auth'] = 'Username incorrect'
        false
      end
    end
  end
  
  def help
  end

  def landing
    render :layout => "landing"
  end
end
