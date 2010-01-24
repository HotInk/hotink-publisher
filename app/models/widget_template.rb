class WidgetTemplate < Template  

  serialize :schema, Array
      
  def parse_schema
    parsed_schema = {}
    self.schema.each do |entity|
      parsed_schema.merge!( {entity['name'] => { 'type' => entity['model'], 'description' => entity['description'], 'ids' => ( entity['quantity'].nil? ? [] : Array.new(entity['quantity'].to_i) ) } } )
    end 
    parsed_schema
  end
  
  private
  
  def find_widgets
    true # Don't load widgets in a widget template
  end
end