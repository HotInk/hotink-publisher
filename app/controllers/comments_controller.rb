class CommentsController < ApplicationController

  layout 'default'

  has_rakismet
  
  before_filter :find_account

  def index
    
    conditions = { :spam => "false" }
    
    if params[:article_id].nil?
      @comments = Comment.find(:all, :conditions => conditions)
    else    
      @article = Article.find(params[:article_id], :params => {:account_id => @account.account_resource_id})
      @comments = @article.comments
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comment }
    end
  end


  def show
    @comment = Comment.find(params[:id], :params => {:account_id => 1})
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end


  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end


  def edit
    @comment = Comment.find(params[:id])
  end


  def create

    @comment = Comment.new(params[:comment])
    @comment.content_id = params[:article_id]
    @comment.account_id = @account.id
    @comment.ip = request.remote_ip
    
    if facebook_session
      @comment.type = "FacebookComment"
      @comment.fb_user_id = facebook_session.user.id
    end
    
    if @comment.spam?
      @comment.spam = true
    end
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(account_article_path(@account, @comment.content_id)) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:Comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.js { head :ok } 
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(Comments_url) }
      format.xml  { head :ok }
    end
  end
  
end
