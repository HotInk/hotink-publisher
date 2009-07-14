class Article < ActiveResource::Base

  self.site = HI_CONFIG["site"]
  self.user = HI_CONFIG["user"]
  self.password = HI_CONFIG["password"]
  self.prefix = "/accounts/:account_id/"

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
