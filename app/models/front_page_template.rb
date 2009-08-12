class FrontPageTemplate < PageTemplate  
  
  serialize :schema, Array
    
  def parse_schema
    parsed_schema = {}
    self.schema.each do |entity|
      parsed_schema.merge!( {entity['name'] => { 'type' => entity['model'], 'description' => entity['description'], 'ids' => ( entity['quantity'].nil? ? [] : Array.new(entity['quantity'].to_i) ) } } )
    end 
    parsed_schema
  end
  
end