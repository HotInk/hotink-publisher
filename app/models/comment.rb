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
  
  def clear_flags
    self.update_attribute(flags, 0)
  end
  
  
  def Comment.clear_all_flags(account_id)
    @comments = Comment.find(:all, :conditions => {:account_id => account_id})
  end

end