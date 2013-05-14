class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def require_http_auth_user
    authenticate_or_request_with_http_basic do |username, password|
      if user = User.find_by_login(username)
        user.valid_password?(password)
      else
        false
      end
    end
  end
  
  protected
  def log_event(category, action, label, value)
    #Gabba event
    Gabba::Gabba.new("UA-40780044-1", "giv-dueren.uni-muenster.de").event(category, action, label, value, true)
    
    #Custom db entry
    Analytics.create(:userid => current_user.id, :category => category, :action => action, :label => label, :value => value)
  end
end
