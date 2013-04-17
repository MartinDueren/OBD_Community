class StaticPagesController < BaseController
  
  def community_map
    
  end

  def help
  end

  def landing
    render :layout => "landing"
  end
end
