class WidgetTemplate < Template  

  serialize :schema, Array
  
  validates_presence_of :schema, :message => " must be present in order to load content for this template."
    
  def parse_schema
    parsed_schema = {}
    self.schema.each do |entity|
      parsed_schema.merge!( {entity['name'] => { 'type' => entity['model'], 'description' => entity['description'], 'ids' => ( entity['quantity'].nil? ? [] : Array.new(entity['quantity'].to_i) ) } } )
    end 
    parsed_schema
  end
  
end