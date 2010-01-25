require 'spec_helper'

describe DesignImportsController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET new" do
    before do
      @public_designs = (1..3).collect { |n| Factory(:design, :public => true, :created_at => (5-n).days.ago.to_time)}
      xhr :get, :new, :account_id => @account.id
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:designs).with(Design.find_all_by_public(true, :order => "created_at DESC"))}
  end
  
  describe "POST create" do
    before do
      controller.stub!(:session).and_return({ :sso => { :is_admin? => true }})
      @design = Factory(:design)
      @templates = (1..3).collect{ Factory(:page_template, :design => @design) }
      @template_files = [Factory(:template_file, :design => @design)]
      xhr :post, :create, :account_id => @account.id, :design_id => @design.id
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:design_to_import).with(@design) }
    it { should assign_to(:design).with_kind_of(Design) }
  end
  
end
