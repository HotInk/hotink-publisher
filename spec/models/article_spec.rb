require 'spec_helper'

describe Article do
    
  it "should find articles by id" do
    Article.should_receive(:find).with(:all, :params => { :ids => [2, 5, 6, 8], :account_id => nil})
    Article.find_by_ids([2, 5, 6, 8])
    
    Article.should_not_receive(:find).with(:all, :params => { :ids => nil, :account_id => nil})
    Article.find_by_ids(nil).should == []
  end
  
  it "should know its publisher account" do
    @article = Factory(:article)
    @account = mock('account')
    Account.should_receive(:find_by_account_resource_id).with(@article.account_id).and_return(@account)
    
    @article.account.should == @account
  end
    
  it "should know its publisher url" do
    @article = Factory(:article)
    @account = mock('account')
    Account.should_receive(:find_by_account_resource_id).with(@article.account_id).and_return(@account)
    @account.should_receive(:url).and_return('/accounts_url')
    
    @article.url.should == "/accounts_url/articles/#{@article.id}"
  end
  
  it "should identify its images" do
    @images = (1..2).collect { Factory(:image) }
    @mediafile = Factory(:mediafile)
    @article = Factory(:article, :mediafiles => @images + [@mediafile])
    
    @images.each do |image|
      @article.images.should include(image)
    end
    @article.images.should_not include(@mediafile)
  end
  
  it "should identify its comments" do
    article = Factory(:article)
    Comment.should_receive(:find).with(:all, :conditions => { :content_id => article.id, :content_type => "Article" })
    
    article.comments
  end
end
