class TripController < BaseController
  
  before_filter :login_required

  uses_tiny_mce do
    {:only => [:show], :options => configatron.default_mce_options}
  end
  
  def show
    puts("show")
  end

  def create
    puts("create")
  end
end
