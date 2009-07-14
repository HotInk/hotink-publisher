class Blog < ActiveResource::Base

  self.site = HI_CONFIG["site"]
  self.user = HI_CONFIG["user"]
  self.password = HI_CONFIG["password"]
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
