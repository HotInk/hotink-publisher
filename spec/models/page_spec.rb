require 'spec_helper'

describe Page do
  
  subject { Factory(:page) }
  
  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }
  
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:account_id) }
  
  it "should generate a liquid-friendly version of itself" do
    page = Factory(:page)
    page.to_liquid.should == {"name"=>page.name, "date"=>nil, "id"=>page.id, "bodytext"=>page.bodytext}
  end
end
