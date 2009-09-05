class Comment < ActiveRecord::Base

  belongs_to :account

  has_rakismet :author => proc { self.name },
               :author_email => proc { self.email },
               :author_url => proc { self.url },               
               :content => proc { self.body }


  def to_liquid(options = {})
    Liquid::CommentDrop.new self, options
  end
  
  def account
    Account.find(self.account_id)
  end
  
  def article
    Article.find(self.content_id, :params => {:account_id => self.account_id})
  end
    
  def Comment.clear_all_flags(account_id)
    @comments = Comment.find(:all, :conditions => {:account_id => account_id})
    @comments.collect{|comment|
      comment.clear_flags
    }
  end
  
  def flag
    self.increment(:flags)
    self.save
  end
  
  def clear_flags
    self.update_attribute(:flags, 0)
    self.save
  end
  
  def enabled?
    self.enabled
  end
  
  def enable
    self.update_attribute(:enabled, true)
  end
  
  def disable
    self.update_attribute(:enabled, false)
  end
  
end