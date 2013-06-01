class Trip < ActiveRecord::Base  
  acts_as_commentable
  
  belongs_to :user
  has_many   :measurements, :foreign_key => 'measurement_id' 
  
  validates_presence_of :login

  attr_accessible :login

  def getTripLength
  	"getTripLength"
  end
  
end
