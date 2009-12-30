class PagesController < ApplicationController
  
  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables, :only => :show
  before_filter :require_design, :only => :show
  
  before_filter :find_template, :only => :show
  before_filter :build_registers, :only => :show
  before_filter :load_widget_data, :only => :show

  layout 'admin', :except => :show

  def show
    
    @page = @account.pages.find_by_name(params[:page_name])
    
    if @page.nil? 
      begin
        @section = Section.find(URI.escape(params[:page_name]), :params => { :account_id => @account.account_resource_id })      
        if @section.nil?
          zissou
          return
        else
          redirect_to "/sections/#{URI.escape(@section.name)}", :status=>:moved_permanently
          return
        end
      rescue NoMethodError # Catch case that "section" we think we have isn't a real section at all 
        zissou
        return
      end
    end

    render :text => @current_template.render({'page' => @page, 'newspaper' => @newspaper}, :registers => @registers )
    
  end
  
  
  def index
    @pages = Page.find_all_by_account_id(@account.id)
  end


  def new
    @page = Page.new
  end


  def edit
    @page = @account.pages.find(params[:id])    
  end


  def create
    @page = @account.pages.build(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to account_pages_path(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update    
    @page = @account.pages.find(params[:id])
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to account_pages_path(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end    
  end


  def destroy
    @page = @account.pages.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(account_pages_url(@account)) }
      format.xml  { head :ok }
    end
  end

end