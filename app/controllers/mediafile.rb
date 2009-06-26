class Mediafile < ActiveResource::Base

  # TODO: make this a configuration option

  # self.site = "http://192.168.1.1"
  self.site = "http://localhost:4000"
  self.prefix = "/accounts/:account_id/articles/:article_id/"
  self.user = "hyfen"
  self.password = "blah123"

end
