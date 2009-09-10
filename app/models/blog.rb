class Blog < HyperactiveResource

  # self.prefix = "/accounts/:account_id/"
  
  belongs_to :account, :nested => true

  def to_liquid
    {'title' => title, 'id' => id, 'description' => description, 'updated_at' => updated_at}
  end

  def entries(access_token = nil)
    raise ArgumentError unless access_token
    Entry.find(:all, :params => {:account_id => self.account_id, :blog_id => self.id}, :as => access_token)
  end
  
  def account_id
    self.prefix_options[:account_id].to_i
  end
  
end
