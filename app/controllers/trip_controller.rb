class TripController < ApplicationController
  include Viewable
          
  before_filter :login_required

  def index
    @user = User.find(params[:user_id])            
    @trips = @user.trips.recent
    @trips = @trips.page(params[:page]).per(10)
    
    @is_current_user = @user.eql?(current_user)

    @rss_title = "#{configatron.community_name}: #{@user.login}'s Trips"
    @rss_url = user_trips_path(@user,:format => :rss)
        
    respond_to do |format|
      format.html # index.rhtml
      format.rss {
        render_rss_feed_for(@trips,
           { :feed => {:title => @rss_title, :link => url_for(:controller => 'trips', :action => 'index', :user_id => @user) },
             :item => {:title => :title,
                       :description => :trip,
                       :link => Proc.new {|trip| user_trip_url(trip.user, trip)}} })
      }
    end
  end
  
    
  # GET /trips/1
  # GET /trips/1.xml
  def show
    @rss_title = "#{configatron.community_name}: #{@user.login}'s trips"
    @rss_url = user_trips_path(@user,:format => :rss)
    
    @trip = Trip.unscoped.find(params[:id])

    @user = @trip.user
    @is_current_user = @user.eql?(current_user)
    @comment = Comment.new(params[:comment])

    @comments = @trip.comments.includes(:user).order('created_at DESC').limit(20)

    @previous = @trip.previous_trip
    @next = @trip.next_trip   
  end
  
  def update_views
    @trip = Post.find(params[:id])
    updated = update_view_count(@trip)
    render :text => updated ? 'updated' : 'duplicate'
  end
  
  def recent
    @trips = Trip.recent.page(params[:page]).per(20)
    
    @rss_title = "#{configatron.community_name} "+:recent_trips.l
    @rss_url = recent_rss_url
    respond_to do |format|
      format.html 
      format.rss {
        render_rss_feed_for(@trips, { :feed => {:title => @rss_title, :link => recent_url},
          :item => {:title => :title, :link => Proc.new {|trip| user_trip_url(trip.user, trip)}}
          })
      }
    end    
  end
  
end
