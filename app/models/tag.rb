class Tag < ActiveResource::Base
  
  def to_liquid
    {'name' => self.name, 'id' => self.id }
  end
    
end