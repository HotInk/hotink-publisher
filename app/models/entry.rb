class Entry < ActiveResource::Base

  self.site = HI_CONFIG["site"]
  self.user = HI_CONFIG["user"]
  self.password = HI_CONFIG["password"]
  self.prefix = "/accounts/:account_id/blogs/:blog_id/"

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
    {'title' => self.title, 'bodytext' => self.bodytext, 'id' => self.id}
  end

end