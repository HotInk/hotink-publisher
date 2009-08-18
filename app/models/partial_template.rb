class PartialTemplate < Template

  has_many :widgets, :through => :widget_placements

end