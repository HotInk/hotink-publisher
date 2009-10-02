class Mediafile < HyperactiveResource

  # self.prefix = "/accounts/:account_id/articles/:article_id/"

  belongs_to :article, :nested => true

  def to_liquid(options = {})
    Liquid::MediafileDrop.new self, options
  end

  def image_url(size)
    self.url.attributes[size]
  end
  
  def original_url
    self.url.attributes["original"]
  end
end
