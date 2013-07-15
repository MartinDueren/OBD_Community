class Analytics < ActiveRecord::Base
  attr_accessible :action, :category, :description, :group, :time, :url, :user_id
end
