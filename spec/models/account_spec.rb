require 'spec_helper'

describe Account do
  it { should validate_presence_of(:account_resource_id) }
  
  it "should find its sections" do
    account = Factory(:account)
    Section.should_receive(:find).with(:all, :params => { :account_id => account.account_resource_id })
    
    account.sections
  end
end
