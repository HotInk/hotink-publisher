class Entry < ActiveResource::Base

  # TODO: make this a configuration option

  # self.site = "http://192.168.1.1"
  self.site = "http://localhost:4000"
  self.prefix = "/accounts/:account_id/blogs/:blog_id/"
  self.user = "hyfen"
  self.password = "blah123"

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
    {'title' => self.title, 'bodytext' => self.bodytext, 'id' => self.id}
  end

end