class CommentsController < ApplicationController

  layout 'default'

  has_rakismet
  
  skip_before_filter :require_user, :only => [:index, :show, :new, :create]

  before_filter :validate_brain_buster, :only => [:create]

  
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

  def create
    
    @comment = Comment.new(params[:comment])
    
    if params[:entry_id]
      @comment.content_id = params[:entry_id]
      @comment.content_type = "Entry"
      redirect_url = "#{@account.url}/blogs/#{params[:blog_id]}/entries/#{params[:entry_id]}"
      
    elsif params[:article_id]
      @comment.content_id = params[:article_id]
      @comment.content_type = "Article"
      redirect_url = "#{@account.url}/articles/#{params[:article_id]}"
    end
    
    @comment.account_id = @account.id
    @comment.ip = request.remote_ip
    
    if @comment.spam?
      @comment.spam = true
    end
  
    
      
    respond_to do |format|
      if @comment.save
        format.html { redirect_to("#{redirect_url}#comment-#{@comment.id}") }
      end
    end
  end




  
end
