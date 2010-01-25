require 'spec_helper'

describe ControlPanelsController, "GET show" do
  before do
    @account = Factory(:account)
    Account.should_receive(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  it "should render the appropriate layout" do
    get :show, :account_id => @account.id
    
    should render_with_layout('admin')
  end
  
  it "builds a new press run" do
    get :show, :account_id => @account.id
    
    should assign_to(:press_run).with_kind_of(PressRun)
  end

  it "build a new redesign, with the current design as it's default" do
    @account.should_receive(:current_design).and_return(Factory(:design, :account => @account))
    
    get :show, :account_id => @account.id
    
    should assign_to(:redesign).with_kind_of(Redesign)
  end
  
  
  it "load the account's draft front-pages" do
    1..3.times { Factory(:front_page, :account => @account) }
    get :show, :account_id => @account.id
    
    should assign_to(:draft_front_pages).with(@account.front_pages.drafts.all(:order => "updated_at DESC", :limit => 15))
  end
    
end
