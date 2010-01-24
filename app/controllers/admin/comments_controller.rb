class Admin::CommentsController < ApplicationController
  layout 'admin'
  
  before_filter :require_user  
  
  def index
    # @comments = Comment.paginate :page => params[:page], :per_page => 50
    conditions = {:account_id => @account.id, :enabled => true, :spam => false}
    
    @comments = Comment.paginate(:page => params[:page], :per_page => 20, :conditions => conditions, :order => "created_at DESC")    
    @articles = hash_by_id(Article.find_by_ids(@comments.collect { |x| x.content_id }.uniq, :account_id => @account.account_resource_id))

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def bulk_action
    for comment_id in params[:comment_ids]
      comment = Comment.find(comment_id.to_i)      
      if params[:action_name] == "clear"
        comment.clear_flags
      elsif params[:action_name] == "remove"
        comment.disable
      elsif params[:action_name] == "spam"
        comment.mark_spam
      end
    end
    redirect_to(account_comments_path) 
  end
  
  def clear_all_flags
    Comment.clear_all_flags(@account.id)
    flash[:notice] = 'Flags cleared'
    respond_to do |format|
        format.html { redirect_to(account_comments_path) }
        format.js { head :ok } 
    end  
  end
  
  def flag
    @comment = Comment.find(params[:id], :conditions => { :account_id => @account.id })    
    @comment.flag
    flash[:notice] = 'Comment was flagged'
    respond_to do |format|
        format.html { redirect_to(account_comments_path) }
        format.js { head :ok } 
    end    
  end
  
  def enable
    @comment = Comment.find(params[:id], :conditions => { :account_id => @account.id })    
    @comment.enable
    flash[:notice] = 'Comment was flagged'
    respond_to do |format|
      format.html { redirect_to(account_comments_path) }
      format.js { head :ok } 
    end
  end  

  def disable
    @comment = Comment.find(params[:id], :conditions => { :account_id => @account.id })    
    @comment.disable
    flash[:notice] = 'Comment was flagged'
    respond_to do |format|
      format.html { redirect_to(account_comments_path) }
      format.js { head :ok } 
    end
  end
  
end
