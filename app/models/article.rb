class Article < ActiveResource::Base

  # TODO: make this a configuration option

  # self.site = "http://192.168.1.1"
  self.site = "http://demo.hotink.net/"
  self.prefix = "/accounts/:account_id/"
  self.user = "hyfen"
  self.password = "blah123"

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
    Liquid::ArticleDrop.new self, options
  end

  def article_options
    ArticleOptions.find_by_article_id_and_account_id(self.id, self.prefix_options[:account_id])
  end

end
