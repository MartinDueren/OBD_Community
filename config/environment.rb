# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OBDComm::Application.initialize!

# Enable ActionMailer for eMail Notifications
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings =  {
  :enable_starttls_auto => true,
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'obdcomm.com',
  :authentication => :plain,
  :user_name => 'obdcomm',
  :password => 'communityengine'
}
