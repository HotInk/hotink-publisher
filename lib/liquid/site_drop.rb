class Liquid::SiteDrop < Liquid::BaseDrop
  
  def initialize(controller, options = {})
    @controller = controller
  end

  # Returns the name of the current controller (for example, "blog").
  def controller
    @controller.controller_name
  end
  
end