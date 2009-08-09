class PageTemplate < Template
  belongs_to :layout
  
  def current_layout
    self.layout || self.design.default_layout
  end
  
end