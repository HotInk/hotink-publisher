class Mediafile < ActiveResource::Base
  
  self.site = HOTINK_SETTINGS[:site]
  self.prefix = "/accounts/:account_id/"

  def to_liquid(options = {})
    Liquid::MediafileDrop.new self, options
  end

  def image_url(size)
    self.url.attributes[size]
  end

end
