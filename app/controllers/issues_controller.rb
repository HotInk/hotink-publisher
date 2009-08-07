class IssuesController < ApplicationController

  layout 'default'

  def show
    
    @issue = Issue.find(params[:id], :params => {:account_id => @account.account_resource_id})
    @articles = Article.find(:all, :params => {:account_id => @account.account_resource_id})  #FIXME: need actual articles from issue
    
  end
  
  def index
    @issues = @account.issues
  end

end