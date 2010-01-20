require 'spec_helper'

describe Account do
  before do
    @account = Factory(:account)
  end
  
  it { should validate_presence_of(:account_resource_id) }
  
  it { should have_many(:front_pages) }
  it { should have_many(:press_runs) }

  it { should have_many(:designs) }
  it { should have_many(:redesigns) }

  it { should have_many(:pages) }
  it { should have_many(:podcasts) }
  
  it { should have_many(:article_options) }

  it "should know which design is currently active and when it was made active" do
    @account.current_design.should be_nil
    @account.current_redesign.should be_nil
    
    design = Factory(:design, :account => @account)
    redesign = Factory(:redesign, :account => @account, :design => design)
    
    @account.current_design.should == design
    @account.current_redesign.should == redesign
  end
  
  it "should know which front page is currently active and when it was made active" do
    @account.current_front_page.should be_nil
    @account.current_press_run.should be_nil
    
    front_page = Factory(:front_page, :account => @account)
    press_run = Factory(:press_run, :account => @account, :front_page => front_page)
    
    @account.current_front_page.should == front_page
    @account.current_press_run.should == press_run
  end

  it "should find its sections" do
    Section.should_receive(:find).with(:all, :params => { :account_id => @account.account_resource_id })
    @account.sections
  end
  
  it "should find its blogs" do
    Blog.should_receive(:find).with(:all, :params => { :account_id => @account.account_resource_id })
    @account.blogs
  end
  
  it "should set a cache-key for memcached" do
    @account.cache_key.should == "accounts/#{@account.account_resource_id}"
  end
end
