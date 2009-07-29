class OauthToken < ActiveRecord::Base
  has_one :user
end
