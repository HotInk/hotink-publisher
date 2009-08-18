class Layout < Template
  has_many :page_templates
  
  has_many :widgets, :through => :widget_placements

end