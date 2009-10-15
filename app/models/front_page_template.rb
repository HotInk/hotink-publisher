class FrontPageTemplate < WidgetTemplate  
  belongs_to :layout
  has_many :widgets, :through => :widget_placements
  
  def current_layout
    self.layout || self.design.default_layout
  end
  
  # Returns all widgets, not just those belonging to this template
  # but also those belonging to this page's layout
  def all_widgets
    found_widgets = self.widgets
    found_widgets += self.current_layout.widgets if self.current_layout
  end
  
end