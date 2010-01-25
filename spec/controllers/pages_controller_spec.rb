require 'spec_helper'

describe PagesController do
  context "when not logged in" do
    before do
      @account = Factory(:account)
      Account.stub!(:find).and_return(@account)
    end
    
    describe "GET show" do
      before do
        @newspaper = Liquid::NewspaperDrop.new(@account)
        Liquid::NewspaperDrop.stub!(:new).and_return(@newspaper)
        @design = Factory(:design, :account => @account)
        @redesign = Factory(:redesign, :account => @account, :design => @design)
        @template = Factory(:page_template, :design => @design)
        Template.should_receive(:find_by_role).and_return(@template)
      end
      
      context "with a page name" do
        before do
          @page = Factory(:page, :account => @account)
          @template.should_receive(:render).with({
            'page' => @page, 
            'newspaper' => @newspaper, 
            'current_user' => nil}, 
            :registers => {
              :account => @account,
              :design => @design
            } )        
          get :show, :account_id => @account.id, :page_name => @page.name
        end
      
        it { should respond_with(:success) }
      end
      
      context "with a section name" do
        before do
          @section = Factory(:section, :account => @account)
          Section.should_receive(:find).with(URI.escape(@section.name), 
              :params => { :account_id => @account.account_resource_id }).and_return(@section)
          get :show, :account_id => @account.id, :page_name => @section.name
        end
        
        it { should respond_with(:redirect) }
      end
      
      context "with nonsense" do        
        it "should handle clear failure" do
          @section = Factory(:section, :account => @account)
          Section.stub!(:find).and_return(nil)
          get :show, :account_id => @account.id, :page_name => "nononono-nothing"
          should respond_with(:not_found) 
        end
        
        it "should handle confused return" do
          @section = Factory(:section, :account => @account)
          Section.stub!(:find).and_return(Array.new)
          get :show, :account_id => @account.id, :page_name => "nononono-nothing"
          should respond_with(:not_found) 
        end
      end
    end
  end
  
  context "when logged in" do
     before do
       @account = Factory(:account)
       Account.stub!(:find).and_return(@account)
       controller.stub!(:require_user).and_return(true)
     end
     
     describe "GET index" do
       before do
         @pages = (1..3).collect{ Factory(:page, :account => @account) }
         get :index, :account_id => @account.id
       end
       
       it { should assign_to(:pages).with(@pages) }
       it { should respond_with(:success) }
       it { should render_template('index') }
     end
     
     describe "GET new" do
       before do
         get :new, :account_id => @account.id
       end
       
       it { should assign_to(:page).with_kind_of(Page) }
       it { should respond_with(:success) }
       it { should render_template('new') }
     end
          
     describe "GET edit" do
       before do
         @page = Factory(:page, :account => @account)
         get :edit, :account_id => @account.id, :id => @page.id
       end
       
       it { should assign_to(:page).with(@page) }
       it { should respond_with(:success) }
       it { should render_template('edit') }
     end
     
     describe "POST create" do
       context "with valid page attributes" do
         before do
           @page = Factory.attributes_for(:page)
           post :create, :account_id => @account.id, :page => @page
         end
       
         it { should assign_to(:page).with_kind_of(Page) }
         it { should respond_with(:redirect) }
       end
       
       context "with invalid page attributes" do
         before do
           @page = Factory.attributes_for(:page, :name => "")
           post :create, :account_id => @account.id, :page => @page
         end

         it { should assign_to(:page).with_kind_of(Page) }
         it { should respond_with(:success) }
         it { should render_template('edit') }
       end
     end
     
     describe "PUT update" do
       context "with valid page attributes" do
         before do
           @page = Factory(:page, :account => @account)
           @new_page = Factory.attributes_for(:page)
           put :update, :account_id => @account.id, :id => @page.id, :page => @new_page
         end
       
         it { should assign_to(:page).with(@page) }
         it { should respond_with(:redirect) }
       end
       
       context "with invalid page attributes" do
         before do
           @page = Factory(:page, :account => @account)
           @new_page = Factory.attributes_for(:page, :name => "")
           put :update, :account_id => @account.id, :id => @page.id, :page => @new_page
         end

         it { should assign_to(:page).with(@page) }
         it { should respond_with(:success) }
         it { should render_template('edit') }
       end
     end
     
     describe "DELETE destroy" do
       before do
         @page = Factory(:page, :account => @account)
         @page.should_receive(:destroy)
         Page.stub!(:find).and_return(@page)
         delete :destroy, :account_id => @account.id, :id => @page.id
       end
       
       it { should respond_with(:redirect) }
     end
   end
end
