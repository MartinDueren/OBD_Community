class Trip < ActiveRecord::Base  
  acts_as_commentable
  
  belongs_to :user
  has_many   :measurements  
  
  validates_presence_of    :trip_id,   :login

  attr_accessible :trip_id, :login
  
end
