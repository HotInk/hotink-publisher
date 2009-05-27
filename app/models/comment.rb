class Comment < ActiveRecord::Base

  def to_liquid(options = {})
    Liquid::CommentDrop.new self, options
  end
  
  def account
    Account.find(self.account_id)
  end
  
  def article
    Article.find(self.content_id, :params => {:account_id => self.account_id})
  end

end