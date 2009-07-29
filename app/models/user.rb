class User < ActiveRecord::Base
  belongs_to :oauth_token
  
  acts_as_authentic
end
