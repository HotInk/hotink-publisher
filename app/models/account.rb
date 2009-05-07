class Account < ActiveResource::Base

  # TODO: make this a configuration option
  self.site = "http://192.168.1.1"
  self.user = "andrew"
  self.password = "blah123"
  
  def articles
    Article.find(:all, :params => {:account_id => self.id})
  end
end
