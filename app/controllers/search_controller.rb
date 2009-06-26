class SearchController < ApplicationController
  
  layout 'default'
  
  def index
    if params[:search].blank?
    else
      @articles = Article.find(:all, :params => {:account_id => @account.id, :search => params[:search]})
    end
      
  end
  
  
end
