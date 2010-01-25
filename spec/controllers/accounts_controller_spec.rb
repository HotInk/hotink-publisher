require 'spec_helper'

describe AccountsController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET show" do
    context "when the account's ready to publish" do
      before do
        @newspaper = Liquid::NewspaperDrop.new(@account)
        Liquid::NewspaperDrop.stub!(:new).and_return(@newspaper)
        @front_page = Factory(:front_page, :account => @account)
        @design = Factory(:design)
        @redesign = Factory(:redesign, :account => @account, :design => @design)
        @press_run = Factory(:press_run, :account => @account, :front_page => @front_page)
      end

      it "should render without featured articles" do
        FrontPage.stub!(:find).and_return(@front_page)
        @front_page.should_receive(:render).with({'newspaper' => @newspaper, 'current_user' => nil}, :registers => { :account => @account, :widget_data => {} })
        
        get :show, :id => @account.id     
        should respond_with(:success)  
        response.headers['Cache-control'].should == "max-age=120, public"
      end
      
      it "should render with featured articles" do
        @articles = (1..3).collect{ Factory(:article) }
        article_ids = @articles.collect{ |a| a.id }
        @front_page.stub!(:schema).and_return('lead_articles' => { 'ids' => article_ids, 'type' => 'Article', 'description' => '' })

        @front_page.should_receive(:schema_article_ids).and_return(article_ids)
        FrontPage.stub!(:find).and_return(@front_page)
        Article.should_receive(:find_by_ids).with(article_ids, :account_id => @account.account_resource_id).and_return(@articles)
        @front_page.should_receive(:render).with({'lead_articles' => @articles, 'newspaper' => @newspaper, 'current_user' => nil}, :registers => { :account => @account, :widget_data => {} })
       
        get :show, :id => @account.id    
        should respond_with(:success)
        response.headers['Cache-control'].should == "max-age=120, public"
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
        
        get :show, :id => @account.id      
        should respond_with(:success)
        response.headers['Cache-control'].should == "max-age=120, public"
      end
    end
  end
end
