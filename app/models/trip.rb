class Trip < ActiveRecord::Base  
  acts_as_commentable
  
  belongs_to :user
  has_many   :measurements  
  
  validates_presence_of :login

  attr_accessible :login
  
end
