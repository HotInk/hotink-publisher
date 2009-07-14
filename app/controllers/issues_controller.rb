class IssuesController < ApplicationController

  layout 'default'

  def show
    
    @issue = Issue.find(params[:id], :params => {:account_id => @account.id})
    @articles = Article.find(:all, :params => {:account_id => @account.id})  #FIXME: need articles from issue
    
  end
  
  def index
    @issues = @account.issues
  end

end