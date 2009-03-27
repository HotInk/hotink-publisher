class Account < ActiveRecord::Base

  has_many :articles
  has_many :themes
  has_many :widgets
  has_many :articles
  has_many :comments
  
  def account_resource_id
    self.id
  end
  
  
end
