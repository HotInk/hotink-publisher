class Blog < HyperactiveResource

  # self.prefix = "/accounts/:account_id/"
  
  belongs_to :account, :nested => true

  def to_liquid
    @blog_drop ||= Liquid::BlogDrop.new self, options
  end

  def entries(access_token = nil)
    raise ArgumentError unless access_token
    Entry.find(:all, :account_id => self.account_id, :blog_id => self.id, :as => access_token)
  end
  
  def account_id
    self.prefix_options[:account_id].to_i
  end
  
end
