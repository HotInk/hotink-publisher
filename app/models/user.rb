class User < ActiveRecord::Base
  belongs_to :oauth_token
  belongs_to :account
  
  acts_as_authentic
end
