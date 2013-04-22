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
end
