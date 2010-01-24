class FrontPagesController < ApplicationController
  
  include ApplicationHelper
  layout 'admin'
   
  before_filter :set_liquid_variables, :only => :show
  before_filter :build_registers, :only => :show

  # GET /front_pages
  def index
    @front_pages = @account.front_pages.find(:all, :order => 'created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /front_pages/1
  def show
    @front_page = @account.front_pages.find(params[:id])
    
    # Build query of only the necessary ids
    schema_ids =  @front_page.schema_article_ids + @front_page.template.required_article_ids
    @schema_articles = {}
    
    # One request to find them all
    unless schema_ids.blank?
      @articles = Article.find_by_ids(schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id)
      @schema_articles = hash_by_id(@articles)  
    end
    @registers[:widget_data] = @front_page.template.parsed_widget_data(@schema_articles)

    render :text => @front_page.render(@front_page.sorted_schema_articles(@schema_articles).merge({'newspaper' => @newspaper, 'current_user' => current_user}), :registers => @registers )
  end

  # GET /front_pages/new
  def new
      respond_to do |format|
        format.html
        format.js
      end
  end

  # GET /front_pages/1/edit
  def edit
    page = params[:page] || 1    
    @articles = Article.paginate(:params => { :page => page, :per_page => 10, :account_id => @account.account_resource_id })
      
    respond_to do |format|
      format.html do
        @front_page = @account.front_pages.find(params[:id])
        @schema_articles = hash_by_id(Article.find_by_ids(@front_page.schema_article_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id))
      end
      format.js
    end
  end

  # POST /front_pages
  def create
    if @account.front_pages.last && @account.front_pages.last.unchanged?  
      @account.front_pages.last.destroy
    end
    
    @front_page_template = FrontPageTemplate.find(params[:template])
    @front_page = @account.front_pages.create(:schema => @front_page_template.parse_schema, :template => @front_page_template)
    flash[:notice] = 'Front page was created.'
            
    respond_to do |format|
      format.html { redirect_to(edit_account_front_page_path(@account, @front_page)) }
    end
  end

  # PUT /front_pages/1
  # PUT /front_pages/1.xml
  def update
    @front_page = @account.front_pages.find(params[:id])
    @front_page.schema = params[:schema] if params[:schema]
    if params[:publish] && params[:publish]=="1"
      @account.press_runs.create(:front_page_id => @front_page.id)
    end
    @front_page.update_attributes(params[:front_page])  
    flash[:notice] = 'FrontPage was successfully updated.'  
    respond_to do |format|
      format.html { redirect_to(account_control_panel_path(@account)) }
    end
  end

  # DELETE /front_pages/1
  # DELETE /front_pages/1.xml
  def destroy
    @front_page = @account.front_pages.find(params[:id])
    @front_page.update_attribute(:active, false)

    respond_to do |format|
      format.html { redirect_to(account_control_panel_url(@account)) }
    end
  end
end
