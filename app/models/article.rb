class Article < ActiveResource::Base

  # TODO: make this a configuration option
  # self.site = "http:/session[:user]/192.168.1.11:3000"
  self.site = "http://localhost:3001"
  self.prefix = "/accounts/:account_id/"

  def comments
    Comment.find_all_by_content_id(self.id)
  end

end
