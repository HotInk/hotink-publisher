require 'spec_helper'

describe RedesignsController, "POST create" do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  it "should redesign the site" do
    design = Factory(:design, :account => @account)
    post :create, :account_id => @account.id, :redesign => { :design_id => design.id }

    should respond_with(:redirect)
    @account.current_design.should == design
  end
end
