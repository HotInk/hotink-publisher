class ArticlesController < ApplicationController
  
  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables
  before_filter :require_design
  
  before_filter :find_template, :only => :show
  
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.find(:all, :account_id => @account.account_resource_id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # Since the show action is public facing, it should always fail in a predictable
  # informative way.
  def show
    @article = Article.find(params[:id], :params => {:account_id => @account.account_resource_id})
    #@comments = @article.comments
    page_html = @current_template.parsed_code.render('article' => @article)
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render('page_content' => page_html )
    else  
      render :text => page_html
    end 
    #render :text => "Sorry, the page you were looking for could not be found.", :status => :not_found # If the current deisgn has no article template we should render 404
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /article/1
  # PUT /article/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(@article) }
        format.js { head :ok } 
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
end
