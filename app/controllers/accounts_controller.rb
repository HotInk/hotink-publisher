class AccountsController < ApplicationController

  skip_before_filter :require_user, :only => :show
  before_filter :build_registers, :only => :show
  
  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    if @account.current_front_page.blank?
      render :text => "This site is currently offline", :status => 503
      return
    end
    @newspaper = Liquid::NewspaperDrop.new(@account)
    
    @front_page = @account.current_front_page
    @current_template = @front_page.template
    
    # Build query of only the necessary ids
    schema_ids = Array.new

    # Only load the Front Page schema if it's provided  
    if @front_page.schema && @front_page.schema.responds_to(:each_key)
      @front_page.schema.each_key do |item|
        schema_ids += @front_page.schema[item]['ids']
      end
    end    

    found_widgets = @current_template.widgets
    found_widgets += @current_template.current_layout.widgets if @current_template.current_layout
    found_widgets.each do |widget|
      widget.schema.each_key do |item|
        schema_ids += widget.schema[item]['ids']
      end
    end
    
    @registers[:account] = @account
    @registers[:design] = @current_template.design
    
    unless schema_ids.blank?          
      # One request to find them all
      article_resources = Article.find(:all, :ids => schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id, :as => @account.access_token)  unless schema_ids.blank?
  
      # Recontruct front page schema as hash keyed by entity name
      data_for_render = {}
      widget_data = {}
      schema_articles = {}
    
      article_resources.each do |article|
        schema_articles.merge!(article.id.to_s => article)
      end
    
      if @front_page.schema && @front_page.schema.responds_to(:each_key)
        @front_page.schema.each_key do |item|
          item_array = @front_page.schema[item]['ids'].collect{ |i| schema_articles[i] }
          data_for_render.merge!( item => item_array )
        end
      end
      
      found_widgets.each do |widget|
        widget.schema.each_key do |item|
          item_array = widget.schema[item]['ids'].collect{ |i| schema_articles[i] }
          widget_data.merge!( "#{item}_#{widget.name}" => item_array )
        end
      end
    
      @registers[:widget_data] = widget_data
    end
    
    page_html = @current_template.parsed_code.render(data_for_render.merge('newspaper' => @newspaper), :registers => @registers )
        
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'newspaper' => @newspaper}, :registers => @registers )
    else  
      render :text => page_html
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to(@account) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to(@account) }
        format.js { head :ok } #The categories-list on the article form posts here. This is it's js. 
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def take_offline
    @account = Account.find(params[:id])
    @redesign = @account.redesigns.create!
    @press_run = @account.press_runs.create!
    flash[:message] = "Site now offline"
    redirect_to account_dashboard_url(@account)
  end
  
  def link_user_accounts
    if self.current_user.nil?
      #register with fb
      User.create_from_fb_connect(facebook_session.user)
    else
      #connect accounts
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
    end
    redirect_to '/'
  end
  
end
