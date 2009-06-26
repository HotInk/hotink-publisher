class Section < ActiveResource::Base

  # TODO: make this a configuration option
  self.site = "http://demo.hotink.net"
  self.prefix = "/accounts/:account_id/"
  self.user = "hyfen"
  self.password = "blah123"
  
  def to_param
    self.name
  end  
  
  def to_liquid
    {'name' => self.name, 'position' => self.position, 'id' => self.id}
  end
  
end
