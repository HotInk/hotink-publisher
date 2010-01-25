class ArticleOptionsController < ApplicationController
  
  layout 'admin'
  
  def index
    page = params[:page] || 1
    
    @articles = Article.paginate(:params => { :account_id => @account.account_resource_id, :page => page, :per_page => 15 } )
    @article_options = @account.article_options.find_all_by_article_id(@articles.collect { |a| a.id })
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def end_comments
    @article = Article.find(params[:article_id], :params => { :account_id => @account.account_resource_id })
    @article_options = @account.article_options.find_or_initialize_by_article_id(@article.id)
    @article_options.comments_enabled = false
    @article_options.save
    
    respond_to do |format|
      format.js { render :partial => 'reload_article' }
    end
    
  end
  
  def start_comments
    @article = Article.find(params[:article_id], :params => { :account_id => @account.account_resource_id })
    @article_options = @account.article_options.find_or_initialize_by_article_id(@article.id)
    @article_options.comments_enabled = true
    @article_options.comments_locked = false
    @article_options.save
        
    respond_to do |format|
      format.js { render :partial => 'reload_article' }
    end
    
  end
  
  def close_comments
    @article = Article.find(params[:article_id], :params => { :account_id => @account.account_resource_id })
    @article_options = @account.article_options.find_or_initialize_by_article_id(@article.id)
    @article_options.comments_enabled = true
    @article_options.comments_locked = true
    @article_options.save
    
    respond_to do |format|
      format.js { render :partial => 'reload_article' }
    end
    
  end
    
end
