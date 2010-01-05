class UserToken < ActiveRecord::Base
  
  after_create :generate_token

private

  def generate_token
    self.token = Digest::SHA1.hexdigest("--#{self.user_id}-mmmm-salty-#{self.created_at.to_s}--")
    self.save 
  end
  
end
