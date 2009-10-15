class PageTemplate < Template
  belongs_to :layout
    
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
  
end