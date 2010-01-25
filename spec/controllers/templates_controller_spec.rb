require 'spec_helper'

describe TemplatesController do
  before do
    @account = Factory(:account)
    @design = Factory(:design, :account => @account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET new" do
    it "should raise error if no role supplied" do
      lambda{ get :new, :account_id => @account.id, :design_id => @design.id  }.should raise_error(ArgumentError)
    end
    
    it "should build layout template" do
      get :new, :account_id => @account.id, :design_id => @design.id, :role => 'layout'
      should assign_to(:tplate).with_kind_of(Layout)
      should render_template(:new)
    end
    
    it "should build partial template" do
      get :new, :account_id => @account.id, :design_id => @design.id, :role => 'partial'
      should assign_to(:tplate).with_kind_of(PartialTemplate)
      should render_template(:new)
    end
    
    it "should build front page template" do
      get :new, :account_id => @account.id, :design_id => @design.id, :role => 'front_pages/show'
      should assign_to(:tplate).with_kind_of(FrontPageTemplate)
      should render_template(:new)
    end
    
    it "should build widget template" do
      get :new, :account_id => @account.id, :design_id => @design.id, :role => 'widget'
      should assign_to(:tplate).with_kind_of(WidgetTemplate)
      should render_template(:new)
    end
    
    it "should build page template" do
      get :new, :account_id => @account.id, :design_id => @design.id, :role => 'articles/show'
      should assign_to(:tplate).with_kind_of(PageTemplate)
      should render_template(:new)
    end
  end

  describe "GET edit" do
    it "should load proper template" do
      template = Factory(:page_template, :design_id => @design.id)
      Template.stub!(:find).and_return(template)
      get :edit, :account_id => @account.id, :design_id => @design.id, :id => template.id
      should assign_to(:tplate).with(template)
    end    
  end

  describe "POST create" do
    it "should create layout template" do
      post :create, :account_id => @account.id, :design_id => @design.id, :layout => Factory.attributes_for(:layout, :role => 'layout', :design => @design)
      assigns[:tplate].should be_kind_of(Layout)
      should respond_with(:redirect)
    end
    
    it "should create partial template" do
      post :create, :account_id => @account.id, :design_id => @design.id, :layout => Factory.attributes_for(:partial_template,  :role => 'partial', :design => @design)
      should assign_to(:tplate).with_kind_of(PartialTemplate)
      should respond_with(:redirect)
    end
    
    it "should create front page template" do
      post :create, :account_id => @account.id, :design_id => @design.id, :layout => Factory.attributes_for(:front_page_template, :role => 'front_pages/show', :design => @design)
      should assign_to(:tplate).with_kind_of(FrontPageTemplate)
      should respond_with(:redirect)
    end
    
    it "should create widget template" do
      post :create, :account_id => @account.id, :design_id => @design.id, :layout => Factory.attributes_for(:widget_template, :role => 'widget', :design => @design)
      should assign_to(:tplate).with_kind_of(WidgetTemplate)
      should respond_with(:redirect)
    end
    
    it "should create page template" do
      post :create, :account_id => @account.id, :design_id => @design.id, :layout => Factory.attributes_for(:page_template, :role => "articles/show", :design => @design)
      should assign_to(:tplate).with_kind_of(PageTemplate)
      should respond_with(:redirect)
    end
    
    it "should raise error on malformed template" do
       post :create, :account_id => @account.id, :design_id => @design.id, :layout => Factory.attributes_for(:page_template, :code => "Bad code {% ", :role => "articles/show", :design => @design)
       should render_template(:new)
       should set_the_flash
    end
  end

  describe "PUT update" do
    it "should save changes to a template" do
      template = Factory(:page_template, :design => @design)
      put :update, :account_id => @account.id, :design_id => @design.id, :id => template.id, :page_template => { :code => "New template code" }
      should set_the_flash
      should respond_with(:redirect)
    end
    
    it "should raise error on malformed template" do
      template = Factory(:page_template, :design => @design)
      put :update, :account_id => @account.id, :design_id => @design.id, :id => template.id, :page_template => { :code => "Bad code {% " }
      should render_template(:edit)
      should set_the_flash
    end
  end
  
  describe "DELETE destroy" do
    it "should delete template" do
      template = Factory(:page_template, :design => @design)
      delete :destroy, :account_id => @account.id, :design_id => @design.id, :id => template.id
      template.reload.should_not be_active
    end
  end
end
