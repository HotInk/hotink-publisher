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
    schema_ids = @current_template.required_article_ids + @front_page.schema_article_ids
    schema_articles = {}
    
    # One request to find them all
    schema_articles = Article.find_and_key_by_id(:ids => schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id, :as => @account.access_token)  unless schema_ids.blank?
  
    @registers[:widget_data] = @current_template.parsed_widget_data(schema_articles)
    
    page_html = @current_template.parsed_code.render(@front_page.sorted_schema_articles(schema_articles).merge('newspaper' => @newspaper), :registers => @registers )
    
    # Squid reverse proxy caching headers
    expires_in 2.minutes, :public => true
    
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
