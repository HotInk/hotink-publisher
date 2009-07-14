class Entry < ActiveResource::Base

  self.site = HOTINK_SETTINGS.site
  self.user = HOTINK_SETTINGS.user
  self.password = HOTINK_SETTINGS.password
  self.prefix = "/accounts/:account_id/blogs/:blog_id/"

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
    {'title' => self.title, 'bodytext' => self.bodytext, 'id' => self.id}
  end

end