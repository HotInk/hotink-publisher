class SearchController < ApplicationController
  
  layout 'default'
  
  def index
    if params[:search].blank?
    else
      @articles = Article.find(:all, :params => {:account_id => @account.account_resource_id, :search => params[:search]})
    end
      
  end
  
  
end
