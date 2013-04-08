class MeasurementController < BaseController
  
  def create
  end

  def show
    @measurement = Measurement.find(params[:id])
    respond_to do |format|
      #format.html # show.html.erb
      format.json { render json: @measurement.geojson }
    end
  end
end
