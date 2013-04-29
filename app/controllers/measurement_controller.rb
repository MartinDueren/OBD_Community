class MeasurementController < BaseController
  
  before_filter :login_with_access_token, :only => [:create]
  
  uses_tiny_mce do
    {:only => [:show], :options => configatron.default_mce_options}
  end

  def show
    respond_to do |format|
      #format.html # show.html.erb
      format.json {
        coordinates = []
        Measurement.where("id = ?", params[:id]).each { |x|
          coordinates << [x.lat,x.lon]
        }
        
        # return a GeoJSON 'FeatureCollection'
        render json:
          { :type => "FeatureCollection",
            :features => [
              :type => "Feature",
              :geometry => {
                :type => "Point",
                :coordinates => coordinates[0]
                },
                :properties => {}
              ]
          }
      }
    end
  end
  
  def create
    @measurement = Measurement.new(params[:measurement])
    
    respond_to do |format|
      if @measurement.save
        format.html { redirect_to @measurement, notice: 'Measurement successfully created.' }
        format.json { render json: @measurement, status: :created}
      else
        format.html { render :layout => "application" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private 
    def login_with_access_token
      if params[:token].nil?
        access_denied
      end
      
      user = User.find_by_single_access_token(params[:token])
      if user.nil?
        access_denied
      else
        UserSession.create(user) if(user.present?)
      end
    end
end
