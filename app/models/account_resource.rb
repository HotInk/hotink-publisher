class AccountResource < ActiveResource::Base

  # TODO: make this a configuration option
  self.site = "http://192.168.1.11:3000"
  self.element_name = "account"

  
end
