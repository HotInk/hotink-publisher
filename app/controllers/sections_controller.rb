class SectionsController < ApplicationController

  layout 'default'

  def show
    @section = Section.find(:one, :from => "/accounts/#{@account.id}/sections/#{params[:id]}.xml")
    @articles = Article.find(:all, :from => "/accounts/#{@account.id}/sections/#{@section.id}/articles.xml")
  end

end