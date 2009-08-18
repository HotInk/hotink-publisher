class FrontPageTemplate < WidgetTemplate  
  belongs_to :layout
  has_many :widgets, :through => :widget_placements
  
  def current_layout
    self.layout || self.design.default_layout
  end
  
end