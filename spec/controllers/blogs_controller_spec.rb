require 'spec_helper'

describe BlogsController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    @newspaper = Liquid::NewspaperDrop.new(@account)
    Liquid::NewspaperDrop.stub!(:new).and_return(@newspaper)
    @design = Factory(:design, :account => @account)
    @redesign = Factory(:redesign, :account => @account, :design => @design)
  end
  
  describe "GET index" do
    before do
      @template = Factory(:page_template, :role => "blogs/index", :design => @design)
      Template.stub!(:find_by_role).and_return(@template)
      
      @blogs = (1..3).collect{ Factory(:blog) }
      @account.should_receive(:blogs).and_return(@blogs)
      @template.should_receive(:render).with({'blogs' => @blogs, 'newspaper' => @newspaper, 'current_user' => nil}, :registers => { :account => @account, :design => @design })
      
      get :index, :account_id => @account.id
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:blogs).with(@blogs) }
  end
  
  describe "GET show" do
    before do
      @template = Factory(:page_template, :role => "blogs/index", :design => @design)
      Template.stub!(:find_by_role).and_return(@template)
      
      @blog = Factory(:blog)
      @entries = (1..3).collect{ Factory(:entry) }
      @entries.stub!(:current_page).and_return(2)
      @entries.stub!(:per_page).and_return(10)
      @entries.stub!(:total_entries).and_return(40)
      Blog.stub!(:find).and_return(@blog)
      Entry.should_receive(:paginate).with(:params => { :blog_id => @blog.id, :account_id => @account.account_resource_id, :page => 1, :per_page => 15 }).and_return(@entries)
      @template.should_receive(:render).with({'blog' => @blog, 'entries' => @entries, 'entries_pagination' => {'current_page' => 2, 'per_page' => 10, 'total_entries' => 40}, 'newspaper' => @newspaper, 'current_user' => nil}, :registers => { :account => @account, :design => @design })
      
      get :show, :account_id => @account.id, :id => @blog.id
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:blog).with(@blog) }
  end
end
