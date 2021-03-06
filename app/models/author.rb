class Author
  
  def initialize(options={})
    self.name = options["name"] if options["name"]
    self.id = options["id"] if options["id"]
  end
  
  attr_accessor :name, :id
  
  def to_liquid
    {'name' => self.name, 'id' => self.id }
  end
    
end