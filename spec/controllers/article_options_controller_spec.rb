require 'spec_helper'

describe ArticleOptionsController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET index" do
    before do
      @articles = (1..3).collect{ Factory(:article) }
    end
    
    describe "view first page" do
      before do
        Article.should_receive(:paginate).with(:params => { :account_id => @account.account_resource_id, :page => 1, :per_page => 15 } ).and_return(@articles)
        @article_options = @articles[1..2].collect{ |a| ArticleOption.create(:article_id => a.id, :account_id => @account.id) }
        get :index, :account_id => @account.id
      end
      
      it { should assign_to(:articles).with(@articles) }
      it { should assign_to(:article_options).with(@article_options) }    
      it { should respond_with(:success) }
      it { should respond_with_content_type(:html) }
    end
    
    describe "paginated articles" do
      before do
        Article.should_receive(:paginate).with(:params => { :account_id => @account.account_resource_id, :page => "2", :per_page => 15 } ).and_return(@articles)
        @article_options = @articles[1..2].collect{ |a| ArticleOption.create(:article_id => a.id, :account_id => @account.id) }
        xhr :get, :index, :account_id => @account.id, :page => 2
      end
      
      it { should assign_to(:articles).with(@articles) }
      it { should assign_to(:article_options).with(@article_options) }    
      it { should respond_with_content_type(:js) }
      it { should respond_with(:success) }
    end
  end
  
  describe "POST end_comments" do
    before do
      @article = Factory(:article)
      Article.should_receive(:find).and_return(@article)
      @article_options = ArticleOption.create(:article_id => @article.id, :account_id => @account.id, :comments_enabled => true)
      xhr :post, :end_comments, :account_id => @account.id, :article_id => @article.id
    end

    it { should assign_to(:article_options).with(@article_options) }
    it { should respond_with_content_type(:js) }
    it { should respond_with(:success) }
    it "should end article comments" do
      @article_options.reload.comments_enabled.should be_false
    end
  end
  
  describe "POST start_comments" do
    before do
      @article = Factory(:article)
      Article.should_receive(:find).and_return(@article)
      @article_options = ArticleOption.create(:article_id => @article.id, :account_id => @account.id, :comments_enabled => false, :comments_locked => true)
      xhr :post, :start_comments, :account_id => @account.id, :article_id => @article.id
    end

    it { should assign_to(:article_options).with(@article_options) }
    it { should respond_with_content_type(:js) }
    it { should respond_with(:success) }
    it "should start article comments" do
      @article_options.reload.comments_enabled.should be_true
      @article_options.comments_locked.should be_false
    end
  end
  
  describe "POST close_comments" do
    before do
      @article = Factory(:article)
      Article.should_receive(:find).and_return(@article)
      @article_options = ArticleOption.create(:article_id => @article.id, :account_id => @account.id, :comments_enabled => false, :comments_locked => false)
      xhr :post, :close_comments, :account_id => @account.id, :article_id => @article.id
    end

    it { should assign_to(:article_options).with(@article_options) }
    it { should respond_with_content_type(:js) }
    it { should respond_with(:success) }
    it "should lock article comments" do
      @article_options.reload.comments_enabled.should be_true
      @article_options.comments_locked.should be_true
    end
  end
end
