class Article < ActiveResource::Base

  # TODO: make this a configuration option

  # self.site = "http://192.168.1.1"
  self.site = "http://localhost:4000"
  self.prefix = "/accounts/:account_id/"
  self.user = "hyfen"
  self.password = "blah123"
  
  liquid_methods :title, :subtitle, :bodytext, :comments, :date, :authors_list

  def comments
    Comment.find_all_by_content_id(self.id)
  end

end
