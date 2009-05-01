class Account < ActiveResource::Base

  # TODO: make this a configuration option
  self.site = "http://192.168.1.1"
  self.user = "varsitypub"
  self.password = "blah123"
    
end
