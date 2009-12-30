class FrontPageTemplate < WidgetTemplate  
  belongs_to :layout
  has_many :widgets, :through => :widget_placements
  
  def current_layout
    self.layout || self.design.default_layout
  end
  
  # Returns all widgets, not just those belonging to this template
  # but also those belonging to this page's layout
  def all_widgets
    if self.current_layout
      return self.widgets + self.current_layout.widgets
    else 
      return self.widgets
    end
  end
  
  def render(options={}, registers={})
    if current_layout
      current_layout.parsed_code.render(options.merge({'page_contents' => parsed_code.render(options, registers)}), registers)
    else
      parsed_code.render(options, registers)
    end
  end
  
end