require 'spec_helper'

describe Issue do  
  it "should know its own account" do
    issue = Factory(:issue)
    issue.account.should == Account.find_by_account_resource_id(issue.account_id)
  end
end
