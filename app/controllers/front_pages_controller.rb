class FrontPagesController < ApplicationController
  
  include ApplicationHelper
  layout 'admin'
   
  before_filter :set_liquid_variables, :only => :show
  before_filter :require_design, :only => :show
  before_filter :find_template, :only => :show
  before_filter :build_registers, :only => :show

  # GET /front_pages
  # GET /front_pages.xml
  def index
    @front_pages = @account.front_pages.find(:all, :order => 'created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @front_pages }
    end
  end

  # GET /front_pages/1
  # GET /front_pages/1.xml
  def show
    @front_page = @account.front_pages.find(params[:id])
    
    # Build query of only the necessary ids
    schema_ids =  @front_page.schema_article_ids + @front_page.template.required_article_ids
    schema_articles = {}
    
    # One request to find them all
    schema_articles = hash_by_id(Article.find_by_ids(schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id))  unless schema_ids.blank?

    @registers[:widget_data] = @front_page.template.parsed_widget_data(schema_articles)
    
    render :text => @front_page.render(@front_page.sorted_schema_articles(schema_articles).merge({'newspaper' => @newspaper, 'current_user' => current_user}), :registers => @registers )
  end

  # GET /front_pages/new
  # GET /front_pages/new.xml
  def new
      respond_to do |format|
        format.html
        format.js
      end
  end

  # GET /front_pages/1/edit
  def edit
    @front_page = @account.front_pages.find(params[:id])
    page = params[:page] || 1
    schema_ids = Array.new

    if @front_page.schema.respond_to?(:each_key)
      @front_page.schema.each_key do |item|
        schema_ids += @front_page.schema[item]['ids'] unless @front_page.schema[item]['ids'].blank?
      end
    end
    
    @schema_articles = {}
    if schema_ids.blank?
      article_resources = []
    else
      article_resources = Article.find_by_ids(schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id)
    end
    article_resources.each do |article|
      @schema_articles.merge!(article.id => article)
    end
      
    @articles = Article.paginate(:params => { :page => page, :per_page => 10, :account_id => @account.account_resource_id })
      
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /front_pages
  # POST /front_pages.xml
  def create
    
    if @account.front_pages.last && @account.front_pages.last.unchanged?  
      @account.front_pages.last.destroy
    end
    
    @front_page = @account.front_pages.build
    
    # Process the schema template into a real schema
    @front_page_template = FrontPageTemplate.find(params[:template])
    @front_page.schema = @front_page_template.parse_schema
    @front_page.template = @front_page_template
        
    respond_to do |format|
      if @front_page.save
        flash[:notice] = 'Front page was created.'
        format.html { redirect_to(edit_account_front_page_path(@account, @front_page)) }
        format.xml  { render :xml => @front_page, :status => :created, :location => [@account, @front_page] }
      else
        flash[:error] = "Error building new front page from template."
        format.html { redirect_to account_front_pages_url(@account) }
        format.xml  { render :xml => @front_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /front_pages/1
  # PUT /front_pages/1.xml
  def update
    @front_page = @account.front_pages.find(params[:id])
    @front_page.schema = params[:schema] if params[:schema]
    
    respond_to do |format|
      if @front_page.update_attributes(params[:front_page])
        
        if params[:publish] && params[:publish]=="1"
          @account.press_runs.create(:front_page_id => @front_page.id)
        end
        
        
        flash[:notice] = 'FrontPage was successfully updated.'
        format.html { redirect_to(account_control_panel_path(@account)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @front_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /front_pages/1
  # DELETE /front_pages/1.xml
  def destroy
    @front_page = @account.front_pages.find(params[:id])
    @front_page.update_attribute(:active, false)

    respond_to do |format|
      format.html { redirect_to(account_control_panel_url(@account)) }
      format.xml  { head :ok }
    end
  end
end
