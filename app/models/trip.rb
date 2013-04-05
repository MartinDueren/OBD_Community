class Trip < ActiveRecord::Base
  include Rakismet::Model
  rakismet_attrs :comment_type => 'trip'
  attr_protected :akismet_attrs  
  
  acts_as_commentable
  
  belongs_to :user
  has_many   :measurements  
  
  validates_presence_of    :trip_id,   :user_id

  attr_accessible :trip_id, :login
  
  class << self
    def recent
      order("trips.published_at DESC")    
    end
  end
  
  def owner
    self.user
  end
  
  def display_title
    "Hello Title"
  end
  
  def previous_post
    self.user.trips.order('published_at DESC').where('published_at < ? and published_as = ?', published_at, 'live').first
  end
  def next_post
    self.user.trips.except(:order).order('published_at DESC').where('published_at > ? and published_as = ?', published_at, 'live').first    
  end
end
