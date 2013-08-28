class AnalyticsController < BaseController
  
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

  def index
  @analytics = Analytics.all
  respond_to do |format|
    format.html { render :layout => "trips" }
    format.csv { send_data @analytics.to_csv }
    format.xls # { send_data @products.to_csv(col_sep: "\t") }
  end
end

end
