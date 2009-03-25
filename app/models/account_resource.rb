class AccountResource < ActiveResource::Base

  # TODO: make this a configuration option
  self.site = "http://localhost:3001"
  self.element_name = "account"

  
end
