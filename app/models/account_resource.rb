class AccountResource < HyperactiveResource

  # TODO: make this a configuration option

  self.site = "http://hotink.theorem.ca"
  self.nested = false
  self.prefix = "/"
  self.element_name = "account"

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
    Liquid::ArticleDrop.new self, options
  end

end
