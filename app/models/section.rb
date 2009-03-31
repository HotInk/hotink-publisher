class Section < ActiveResource::Base

  # TODO: make this a configuration option
  # self.site = "http://192.168.1.11:3000"
  self.site = "http://localhost:3001"
  self.prefix = "/accounts/:account_id/"

end
