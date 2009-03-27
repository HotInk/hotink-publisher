class Article < ActiveRecord::Base
  belongs_to :account
  
  def article_resource
    begin
      ArticleResource.find(self.article_resource_id, :params => {:account_id => self.account_resource_id})
    rescue ActiveResource::ResourceNotFound
      return nil
    end
  end

  def account_resource_id
    self.account.account_resource_id
  end
end
