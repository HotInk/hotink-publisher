class Section < ActiveResource::Base

  # TODO: make this a configuration option
  self.site = "http://localhost:4000"
  self.prefix = "/accounts/:account_id/"
  self.user = "hyfen"
  self.password = "blah123"
    
end
