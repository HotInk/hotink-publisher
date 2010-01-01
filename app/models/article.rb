class Article < ActiveResource::Base
  
  self.site = HOTINK_SETTINGS[:site]
  self.prefix = "/accounts/:account_id/"
  
  def self.find_by_ids(ids=[], options={})
    find(:all, :params => { :ids => ids, :account_id => options[:account_id] })
  end

  def to_liquid(options = {})
    @article_drop ||= Liquid::ArticleDrop.new self, options
  end
  
  def account
    @account ||= Account.find_by_account_resource_id(self.account_id)
  end
  
  def account_id
    self.prefix_options[:account_id]
  end
  
  def url
    @url ||= account.url + "/articles/" + self.id.to_s
  end

  def images
    self.mediafiles.select{|mediafile| mediafile.mediafile_type == "Image"}
  end
  
  def comments
    Comment.find(:all, :conditions => { :content_id => id, :content_type => "Article"})
  end

end