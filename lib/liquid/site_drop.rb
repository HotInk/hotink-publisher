class Liquid::SiteDrop < Liquid::BaseDrop
  
  def initialize(controller, options = {})
    @controller = controller
  end

  # Returns the name of the current controller (for example, "blog").
  def controller
    @controller.controller_name
  end
  
  def account_id
    @controller.params[:account_id]
  end
  
  def latest_comments
    Comment.find(:all, :limit => 10, :order => "created_at DESC")
  end  
  
end