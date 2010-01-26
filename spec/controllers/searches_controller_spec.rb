require 'spec_helper'

describe SearchesController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET show" do
    before do
      @newspaper = Liquid::NewspaperDrop.new(@account)
      Liquid::NewspaperDrop.stub!(:new).and_return(@newspaper)
      @design = Factory(:design)
      @redesign = Factory(:redesign, :account => @account, :design => @design)
      @template = Factory(:page_template,:role => "searches/show", :design => @design)
      Template.stub!(:find_by_role).and_return(@template)
    end

    context "keyword search" do
      before do
        @articles = (1..3).collect{ Factory(:article) }
        @articles.stub!(:current_page).and_return(1)
        @articles.stub!(:per_page).and_return(15)
        @articles.stub!(:total_entries).and_return(60)
        
        @template.should_receive(:render)
        Article.should_receive(:paginate).with(:params => { :search => "test query", :account_id => "#{@account.account_resource_id}", :page => 1, :per_page => 15 }).and_return(@articles)
        get :show, :account_id => @account.id, :q => "test query"
      end
      
      it { should respond_with(:success) }
    end
    
    context "tag search" do
      before do
        @articles = (1..3).collect{ Factory(:article) }
        @articles.stub!(:current_page).and_return(1)
        @articles.stub!(:per_page).and_return(15)
        @articles.stub!(:total_entries).and_return(60)
        
        @template.should_receive(:render)
        Article.should_receive(:paginate).with(:params => { :tagged_with => "test tags", :account_id => "#{@account.account_resource_id}", :page => 1, :per_page => 15 }).and_return(@articles)
        get :show, :account_id => @account.id, :tagged_with => "test tags"
      end
      
      it { should respond_with(:success) }
    end
  end
  
end
