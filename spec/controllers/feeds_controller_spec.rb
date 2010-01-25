require 'spec_helper'

describe FeedsController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET show" do
    before do
      @articles = (1..5).collect{ Factory(:article, :account => @account) }
      @articles.stub!(:current_page).and_return(1)
      @articles.stub!(:per_page).and_return(15)
      @articles.stub!(:total_entries).and_return(60)
      Article.stub!(:paginate).and_return(@articles)
      
      @account.stub!(:formal_name).and_return("My Paper")
      
      get :show, :account_id => @account.id
    end

    it { should assign_to(:articles).with(@articles) }
    it { should assign_to(:articles_pagination).with({ 'current_page' => 1, 'per_page' => 15, 'total_entries' => 60 })}
    it { should assign_to(:feed_title).with("My Paper main article feed")}
    it { should assign_to(:feed_description).with("Most recent articles from My Paper")}  
    it { should assign_to(:feed_url).with("http://test.host/accounts/#{@account.id}/feed") }
    it "should set the page to cache for 10 minutes" do
      response.headers['Cache-control'].should == "max-age=600, public"  
    end
    it { should respond_with_content_type(:rss) }
  end
end
