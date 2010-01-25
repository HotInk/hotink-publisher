class Tag < ActiveResource::Base

  self.site = HOTINK_SETTINGS[:site]
  self.prefix = "/accounts/:account_id/"
    
  def to_liquid
    {'name' => self.name, 'id' => self.id }
  end
    
end