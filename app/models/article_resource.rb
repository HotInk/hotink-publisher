class ArticleResource < ActiveResource::Base
  # self.site = "http://192.168.1.11:3000"
  self.site = "http://localhost:3001"

  self.prefix = "/accounts/:account_id/"
  self.element_name = "article"

end
