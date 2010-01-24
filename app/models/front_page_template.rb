class FrontPageTemplate < Template  
  belongs_to :layout
  has_many :widgets, :through => :widget_placements
  
  serialize :schema, Array
      
  def parse_schema
    parsed_schema = {}
    self.schema.each do |entity|
      parsed_schema.merge!( {entity['name'] => { 'type' => entity['model'], 'description' => entity['description'], 'ids' => ( entity['quantity'].nil? ? [] : Array.new(entity['quantity'].to_i) ) } } )
    end 
    parsed_schema
  end
  
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
      current_layout.render(options.merge({'page_content' => Marshal.load(parsed_code).render(options, registers)}), registers)
    else
      Marshal.load(parsed_code).render(options, registers)
    end
  end
  
end