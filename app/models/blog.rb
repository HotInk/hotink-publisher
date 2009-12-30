class Blog < ActiveResource::Base

  self.site = HOTINK_SETTINGS[:site]
  self.prefix = "/accounts/:account_id/"
    
  #has_many :podcasts

  def to_liquid(options = {})
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
