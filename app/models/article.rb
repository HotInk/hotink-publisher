class Article < ActiveRecord::Base
  belongs_to :account
  
  def article_resource
    ArticleResource.find(self.article_resource_id, :params => {:account_id => self.account_id})
  end

  def account_resource_id
    self.account.account_resource_id
  end
end
