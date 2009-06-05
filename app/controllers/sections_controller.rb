class SectionsController < ApplicationController

  theme 'varsity'
  layout 'default'

  def show
    @section = Section.find(params[:id], :params => {:account_id => @account.id})
    
    @articles = Article.find(:all, :from => "/accounts/#{@account.id}/sections/#{@section.id}/articles.xml")
  end

end