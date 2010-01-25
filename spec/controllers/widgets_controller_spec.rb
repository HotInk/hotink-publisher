require 'spec_helper'

describe WidgetsController do
  include ApplicationHelper
  
  before do
    @account = Factory(:account)
    @design = Factory(:design, :account => @account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET new" do
    it "should respond to HTML" do
      get :new, :account_id => @account.id, :design_id => @design
      should respond_with(:success)
      should respond_with_content_type(:html)
    end
    
    it "should respond to HTML" do
      xhr :get, :new, :account_id => @account.id, :design_id => @design.id
      should respond_with(:success)
      should respond_with_content_type(:js)
    end
  end
  
  describe "GET edit" do
    before do
      @widget = Factory(:widget, :design => @design)
    end
    context "when there are no schema articles" do
      before do
        Widget.should_receive(:find).and_return(@widget)
        Article.should_receive(:paginate).with(:params => { :page => 1, :per_page => 10, :account_id => @account.account_resource_id })
        get :edit, :account_id => @account.id, :design_id => @design.id, :id => @widget.id
      end
      
      it { should respond_with(:success) }
    end
    
    context "when there are schema articles" do      
      before do
        @articles = (1..3).collect{ Factory(:article) }
        article_ids = @articles.collect{ |a| a.id }
        @widget.stub!(:schema).and_return('lead_articles' => { 'ids' => article_ids, 'type' => 'Article', 'description' => '' })
        Article.should_receive(:find_by_ids).with(article_ids, :account_id => @account.account_resource_id).and_return(@articles)
        
        Widget.should_receive(:find).and_return(@widget)
        Article.should_receive(:paginate).with(:params => { :page => 1, :per_page => 10, :account_id => @account.account_resource_id })
        get :edit, :account_id => @account.id, :design_id => @design.id, :id => @widget.id
      end

      it { should respond_with(:success) }
      it { should assign_to(:schema_articles).with(hash_by_id(@articles)) }
    end
    
    context "when requesting more articles" do
      before do
        Article.should_receive(:paginate).with(:params => { :page => "2", :per_page => 10, :account_id => @account.account_resource_id })
        xhr :get, :edit, :account_id => @account.id, :design_id => @design.id, :id => @widget.id, :page => 2
      end
      
      it { should respond_with(:success) }
      it { should respond_with_content_type(:js) }
    end
  end
  
  describe "POST create" do
    before do
      @widget_template = Factory(:widget_template)
      WidgetTemplate.should_receive(:find).and_return(@widget_template)
      post :create, :account_id => @account.id, :design_id => @design.id, :template => @widget_template.id
    end
    
    it { should respond_with(:redirect) }
    it { should set_the_flash.to('Widget was successfully created.') }
  end
  
  describe "PUT update" do
    context "with appropiate parameters" do
      before do
        @widget = Factory(:widget, :design => @design)
        put :update, :account_id => @account.id, :design_id => @design.id, :id => @widget.id, :front_page => Factory.attributes_for(:widget)
      end
      
      it { should set_the_flash }
      it { should respond_with(:redirect) }
    end
  end
  
  describe "DELETE destroy" do
    before do
      @widget = Factory(:widget, :design => @design)
      @widget.should_receive(:destroy)
      Widget.should_receive(:find).and_return(@widget)
      delete :destroy, :account_id => @account.id, :design_id => @design.id, :id => @widget.id
    end
    
    it { should respond_with(:redirect) }
  end
  
end
