class Section < ActiveResource::Base

  self.site = HI_CONFIG["site"]
  self.user = HI_CONFIG["user"]
  self.password = HI_CONFIG["password"]
  self.prefix = "/accounts/:account_id/"
  
  def to_param
    self.name
  end  
  
  def to_liquid
    {'name' => self.name, 'position' => self.position, 'id' => self.id}
  end
  
end
