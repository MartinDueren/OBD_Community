class AnalyticsController < ApplicationController
  
  def create
  	a = Analytics.new(:user_id => params[:user_id], :action => params[:action_name], :url => "#{params[:url]}", :description => params[:description], :group => params[:group], :category => params[:category])
    
    if a.save
        render :nothing => true, :status => :created
    else
        render :nothing => true, :status => :bad_request
    end
  end

  def show
  end

end
