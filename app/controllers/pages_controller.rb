class PagesController < ApplicationController
  
  layout 'default'

  def show
    @page = Page.find_by_name(params[:page_name])
    
    if @page.nil? 

      # section = Section.find_by_name(params[:page_name])  # FIXME: waiting on API to do section lookups by name
      @section = Section.find(params[:page_name], :params => {:account_id => @account.id})
      
      unless @section.nil?
        redirect_to account_section_url(@account, @section), :status=>:moved_permanently
      end

    end
  end

  def new

  end

  def edit
    @page = Page.find(params[:id])
  end


  def create

  end


  def update

  end


  def destroy

  end

end