class FrontPageTemplate < Template  
  belongs_to :layout
  
  def current_layout
    self.layout || self.design.default_layout
  end
  
  serialize :schema, Array
  
  validates_presence_of :schema, :message => " must be present in order to load content for the front page."
    
  def parse_schema
    parsed_schema = {}
    self.schema.each do |entity|
      parsed_schema.merge!( {entity['name'] => { 'type' => entity['model'], 'description' => entity['description'], 'ids' => ( entity['quantity'].nil? ? [] : Array.new(entity['quantity'].to_i) ) } } )
    end 
    parsed_schema
  end
  
end