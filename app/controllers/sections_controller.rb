class SectionsController < ApplicationController

  layout 'default'

  def show

    @section = Section.find(:one, :from => "/accounts/#{@account.account_resource_id}/sections/#{params[:id]}.xml")
    
    # TODO: should hit the main article controller with a condition instead
    @articles = Article.find(:all, :from => "/accounts/#{@account.account_resource_id}/sections/#{@section.id}/articles.xml")
    
      
  end

end