class AccountResource < ActiveResource::Base

  # TODO: make this a configuration option

  # self.site = "http://192.168.1.1"
  self.site = HOTINK_SETTINGS.site
  self.user = HOTINK_SETTINGS.user
  self.password = HOTINK_SETTINGS.password
  self.element_name = "account"

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
    Liquid::ArticleDrop.new self, options
  end

end
