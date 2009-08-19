class PagesController < ApplicationController
  
  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables, :only => :show
  before_filter :require_design, :only => :show
  
  before_filter :find_template, :only => :show
  before_filter :build_registers, :only => :show

  layout 'admin', :except => :show

  def show
    
    @page = @account.pages.find_by_name(params[:page_name])
    
    if @page.nil? 
      @section = Section.find(params[:page_name], :account_id => @account.id, :as => @access_token)      
      unless @section.nil?
        redirect_to account_section_url(@account, @section), :status=>:moved_permanently
      end
    end

    # Set registers here 
    @registers[:account] = @account
    @registers[:design] = @current_template.design

    page_html = @current_template.parsed_code.render({'page' => @page, 'newspaper' => @newspaper}, :registers => @registers )
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'newspaper' => @newspaper}, :registers => @registers)
    else  
      render :text => page_html
    end    
    
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