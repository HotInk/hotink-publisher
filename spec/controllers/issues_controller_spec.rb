require 'spec_helper'

describe IssuesController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    @design = Factory(:design, :account => @account)
    @redesign = Factory(:redesign, :account => @account, :design => @design)
    @newspaper = Liquid::NewspaperDrop.new(@account)
    Liquid::NewspaperDrop.stub!(:new).and_return(@newspaper)
  end

  describe "GET show" do
    before do
      @issue = Factory(:issue, :account => @account)
      Issue.stub!(:find).and_return(@issue)
      @template = Factory(:page_template, :design => @design, :role => 'issues/show')
      
      controller.should_receive(:render).with(:text => @template.render({
        'issue' => @issue, 
        'newspaper' => @newspaper, 
        'current_user' => nil}, 
        :registers => {
            :account => @account,
            :design => @design,
            :widget_data => {}
        }))
      get :show, :account_id => @account.id, :id => @issue.id
    end
    
    it { should respond_with(:success) }
  end
  
  
  describe "GET index" do
    before do
      @issues = Factory(:issue, :account => @account)
      @issues.stub!(:current_page).and_return(1)
      @issues.stub!(:per_page).and_return(15)
      @issues.stub!(:total_entries).and_return(60)
      
      Issue.stub!(:paginate).and_return(@issues)
      @template = Factory(:page_template, :design => @design, :role => 'issues/index')
      
      controller.should_receive(:render).with(:text => @template.render({
        'issues' => @issues, 
        'issues_pagination' => { 'current_page' => 1, 'per_page' => 15, 'total_entries' => 60 },
        'newspaper' => @newspaper, 
        'current_user' => nil}, 
        :registers => {
          :account => @account,
          :design => @design,
          :widget_data => {}
        }))
      get :index, :account_id => @account.id
    end
    
    it { should respond_with(:success) }
  end
end
