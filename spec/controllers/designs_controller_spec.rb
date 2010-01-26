require 'spec_helper'

describe DesignsController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET index" do
    before do
      @designs = (1..3).collect{ Factory(:design, :account => @account) }
      get :index, :account_id => @account.id
    end
    
    it { should assign_to(:designs).with(@designs) }
    it { should respond_with(:success) }
    it { should respond_with_content_type(:html) }
  end
  
  describe "GET show" do
    before do
      @design = Factory(:design, :account => @account)
      get :show, :account_id => @account.id, :id => @design.id
    end
    
    it { should assign_to(:design).with(@design) }
    it { should respond_with(:success) }
    it { should respond_with_content_type(:html) }
  end
  
  describe "GET new" do
    before do
      get :new, :account_id => @account.id
    end
    
    it { should assign_to(:design).with_kind_of(Design) }
    it { should respond_with(:success) }
    it { should respond_with_content_type(:html) }
  end
  
  describe "GET edit" do
    before do
      @design = Factory(:design, :account => @account)
      get :edit, :account_id => @account.id, :id => @design.id
    end
    
    it { should assign_to(:design).with(@design) }
    it { should respond_with(:success) }
    it { should respond_with_content_type(:html) }
  end
  
  describe "POST create" do
    context "with valid attributes" do
      before do
        @design_attributes = Factory.attributes_for(:design, :account => @account)
        post :create, :account_id => @account.id, :design => @design_attributes
      end
    
      it { should assign_to(:design).with_kind_of(Design) }
      it { should respond_with(:redirect) }
      it { should set_the_flash.to(/success/) }
    end
    
    context "without valid attributes" do
      before do
        @design_attributes = Factory.attributes_for(:design, :name => "", :account => @account)
        post :create, :account_id => @account.id, :design => @design_attributes
      end
    
      it { should assign_to(:design).with_kind_of(Design) }
      it { should respond_with(:success) }
      it { should render_template(:new) }
    end
  end
  
  describe "PUT update" do
    context "with valid attributes" do
      before do
        @design_attributes = Factory.attributes_for(:design, :account => @account)
        @design = Factory(:design, :account => @account)
        put :update, :account_id => @account.id, :id => @design.id, :design => @design_attributes
      end
    
      it { should assign_to(:design).with_kind_of(Design) }
      it { should respond_with(:redirect) }
    end
    
    context "without valid attributes" do
      before do
        @design_attributes = Factory.attributes_for(:design, :name => "", :account => @account)
        @design = Factory(:design, :account => @account)
        
        put :update, :account_id => @account.id, :id => @design.id, :design => @design_attributes
      end
    
      it { should assign_to(:design).with(@design) }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end
  end
  
  describe "DELETE destroy" do
    before do
      @design = Factory(:design, :account => @account)
      delete :destroy, :account_id => @account.id, :id => @design.id
    end
    
    it "should deactivate the front page" do
      @design.reload.active.should be_false
    end
    it { should respond_with(:redirect) }
  end
end
