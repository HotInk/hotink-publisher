require 'spec_helper'

describe UserToken do
  before do
    @user_token = UserToken.create!(:user_id =>1)
  end
  
  it "should generate a onetime-use authorization token" do
    @user_token.token.should == Digest::SHA1.hexdigest("--#{@user_token.user_id}-mmmm-salty-#{@user_token.created_at.to_s}--") 
  end
end
