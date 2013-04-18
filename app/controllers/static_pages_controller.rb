class StaticPagesController < BaseController
  
  def community_map
    render :layout => "fullmap"
  end

  def help
  end

  def landing
    render :layout => "landing"
  end
end
