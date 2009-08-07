class Mediafile < HyperactiveResource

  self.site = HOTINK_SETTINGS.site
  self.user = HOTINK_SETTINGS.user
  self.password = HOTINK_SETTINGS.password
  # self.prefix = "/accounts/:account_id/articles/:article_id/"

  belongs_to :article, :nested => true
  
  
  def to_liquid
    {'title' => self.title, 'caption' => self.caption, 'id' => self.id}
  end
  
end
