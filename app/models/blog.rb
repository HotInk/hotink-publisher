class Blog < ActiveResource::Base

  self.site = HOTINK_SETTINGS.site
  self.user = HOTINK_SETTINGS.user
  self.password = HOTINK_SETTINGS.password
  self.prefix = "/accounts/:account_id/"

  def to_liquid
    {'title' => title, 'id' => id, 'description' => description, 'updated_at' => updated_at}
  end

  def entries
    Entry.find(:all, :params => {:account_id => self.account_id, :blog_id => self.id})
  end
  
  def account_id
    self.prefix_options[:account_id].to_i
  end
  
end
