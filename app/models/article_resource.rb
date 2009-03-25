class ArticleResource < ActiveResource::Base

  # TODO: make this a configuration option
  self.site = "http://localhost:3001"
  self.prefix = "/accounts/:account_id/"
  self.element_name = "article"

end
