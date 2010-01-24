class CommentsController < ApplicationController

  layout 'default'

  has_rakismet
  
  skip_before_filter :require_user, :only => :create
  before_filter :validate_brain_buster, :only => :create

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
    @comment.save
    
    respond_to do |format|
      format.html { redirect_to("#{redirect_url}#comment-#{@comment.id}") }
    end
  end
  
end
