require 'spec_helper'

describe FrontPagesController do
  include ApplicationHelper
  
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET index" do
    before do
      (1..3).collect{ Factory(:front_page, :account => @account)}
      get :index, :account_id => @account.id
    end
    
    it { should assign_to(:front_pages).with(@account.front_pages.find(:all, :order => 'created_at DESC')) }
    it { should render_template(:index) }
  end
  
  describe "GET new" do
    it "should respond to html" do
      get :new, :account_id => @account.id
      should respond_with(:success)
      should respond_with_content_type(:html)
    end
    
    it "should respond to ajax" do
      xhr :get, :new, :account_id => @account
      should respond_with(:success)
      should respond_with_content_type(:js)
    end
  end
  
  describe "GET show" do
    context "when the account's ready to publish" do
      before do
        @newspaper = Liquid::NewspaperDrop.new(@account)
        Liquid::NewspaperDrop.stub!(:new).and_return(@newspaper)
        @front_page = Factory(:front_page, :account => @account)
      end

      it "should render without featured articles" do
        FrontPage.stub!(:find).and_return(@front_page)
        Article.should_not_receive(:find_by_ids)
        @front_page.should_receive(:render).with({'newspaper' => @newspaper, 'current_user' => nil}, :registers => { :account => @account, :widget_data => {} })
        
        get :show, :account_id => @account.id, :id => @front_page.id      
        should respond_with(:success)  
      end
      
      it "should render with featured articles" do
        @articles = (1..3).collect{ Factory(:article) }
        article_ids = @articles.collect{ |a| a.id }
        @front_page.stub!(:schema).and_return('lead_articles' => { 'ids' => article_ids, 'type' => 'Article', 'description' => '' })

        @front_page.should_receive(:schema_article_ids).and_return(article_ids)
        FrontPage.stub!(:find).and_return(@front_page)
        Article.should_receive(:find_by_ids).with(article_ids, :account_id => @account.account_resource_id).and_return(@articles)
        @front_page.should_receive(:render).with({'lead_articles' => @articles, 'newspaper' => @newspaper, 'current_user' => nil}, :registers => { :account => @account, :widget_data => {} })
       
        get :show, :account_id => @account.id, :id => @front_page.id      
        should respond_with(:success) 
      end
      
      it "should render with widget" do
        @articles = (1..3).collect{ Factory(:article) }
        article_ids = @articles.collect{ |a| a.id }
        @widget = Factory(:widget)
        @widget.stub!(:schema).and_return('lead_articles' => { 'ids' => article_ids, 'type' => 'Article', 'description' => '' })
        
        @front_page.template.should_receive(:required_article_ids).and_return(article_ids)
        @front_page.template.widgets << @widget
        FrontPage.stub!(:find).and_return(@front_page)
        Article.should_receive(:find_by_ids).with(article_ids, :account_id => @account.account_resource_id).and_return(@articles)
        @front_page.should_receive(:render).with({'newspaper' => @newspaper, 'current_user' => nil}, :registers => { :account => @account, :widget_data => {"lead_articles_#{@widget.name}" => @articles } })
        
        get :show, :account_id => @account.id, :id => @front_page.id      
        should respond_with(:success)
      end
    end
  end
  
  describe "GET edit" do
    before do
      @front_page = Factory(:front_page, :account => @account)
    end
  
    context "when there are no schema articles" do
      before do
        FrontPage.should_receive(:find).and_return(@front_page)
        Article.should_receive(:paginate).with(:params => { :page => 1, :per_page => 10, :account_id => @account.account_resource_id })
        get :edit, :account_id => @account.id, :id => @front_page.id
      end
      
      it { should respond_with(:success) }
    end
    
    context "when there are schema articles" do      
      before do
        @articles = (1..3).collect{ Factory(:article) }
        article_ids = @articles.collect{ |a| a.id }
        @front_page.stub!(:schema).and_return('lead_articles' => { 'ids' => article_ids, 'type' => 'Article', 'description' => '' })
        Article.should_receive(:find_by_ids).with(article_ids, :account_id => @account.account_resource_id).and_return(@articles)
        
        FrontPage.should_receive(:find).and_return(@front_page)
        Article.should_receive(:paginate).with(:params => { :page => 1, :per_page => 10, :account_id => @account.account_resource_id })
        get :edit, :account_id => @account.id, :id => @front_page.id
      end

      it { should respond_with(:success) }
      it { should assign_to(:schema_articles).with(hash_by_id(@articles)) }
    end
    
    context "when requesting more articles" do
      before do
        Article.should_receive(:paginate).with(:params => { :page => "2", :per_page => 10, :account_id => @account.account_resource_id })
        xhr :get, :edit, :account_id => @account.id, :id => @front_page.id, :page => 2
      end
      
      it { should respond_with(:success) }
      it { should respond_with_content_type(:js) }
    end
  end
  
  describe "POST create" do
    before do
      @stale_front_page = Factory(:front_page, :account => @account)
      @template = Factory(:front_page_template)
      FrontPageTemplate.should_receive(:find).with(@template.id.to_s).and_return(@template)
      post :create, :account_id => @account.id, :template => @template.id
    end
    
    it { should respond_with(:redirect) }
    it { should set_the_flash.to('Front page was created.') }
  end
  
  describe "PUT update" do
    context "with appropiate parameters" do
      before do
        @front_page = Factory(:front_page, :account => @account)
        put :update, :account_id => @account.id, :id => @front_page.id, :front_page => Factory.attributes_for(:front_page)
      end
      
      it { should respond_with(:redirect) }
    end
    
    describe "publishing a front page" do
      before do
        @front_page = Factory(:front_page, :account => @account)
        FrontPage.stub!(:find).and_return(@front_page)
        put :update, :account_id => @account.id, :id => @front_page.id, :publish => 1
      end
      
      it "should make that front page current" do
        @account.current_front_page.should == @front_page
      end
    end
  end
  
  describe "DELETE destroy" do
    before do
      @front_page = Factory(:front_page, :account => @account)
      FrontPage.should_receive(:find).and_return(@front_page)
      delete :destroy, :account_id => @account.id, :id => @front_page.id
    end
    
    it "should deactivate the front page" do
      @front_page.active.should be_false
    end
    it { should respond_with(:redirect) }
  end
end
