class Account < ActiveRecord::Base

  def account_resource
    AccountResource.find(self.account_resource_id)
  end

  def articles
    Article.find(:all, :params => {:account_id => self.id})
  end
  
  def sections
    Section.find(:all, :params => {:account_id => self.id})
  end
  
  def issues
    Issue.find(:all, :params => {:account_id => self.id})
  end
  
  def pages
    Page.find(:all, :conditions => {:account_id => self.id})
  end

  def blogs
    Blog.find(:all, :params => {:account_id => self.id})
  end
  
  def account_resource
    if self.account_resource_id
      AccountResource.find(self.account_resource_id) 
    else
      AccountResource.find(self.id)
    end
  end
  
  def url
    return "http://localhost:3000/accounts/1"
  end
  
end
