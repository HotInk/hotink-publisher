require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  
  it "should make options from initialization hash" do
    user = User.new({:user_id => 2, :email => "test@testaddress.com"})
    user.id.should == 2
    user.email.should == "test@testaddress.com"
  end
  
  it "should expose it's details to Liquid" do
    user = User.new({:user_id => 2, :email => "test@testaddress.com"})
    user.to_liquid.should == {'id' => 2, 'email' => "test@testaddress.com"}
  end
end