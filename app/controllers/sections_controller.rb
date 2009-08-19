class SectionsController < ApplicationController

  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables, :only => :show
  before_filter :find_template, :only => :show

  before_filter :build_registers, :only => :show

  def show
    @section = Section.find(:one, :from => "/accounts/#{@account.account_resource_id}/sections/#{params[:id]}.xml", :as => @access_token)
    
    # FIXME: doesn't actually pull section articles
    @articles = Article.find(:all, :account_id => @account.account_resource_id, :section_id => params[:id], :as => @access_token)
   
    @registers[:account] = @account
    @registers[:design] = @current_template.design
   
    page_html = @current_template.parsed_code.render({'section' => @section, 'articles' => @articles, 'newspaper' => @newspaper}, :registers => @registers )
     if @current_template.current_layout
       render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'newspaper' => @newspaper}, :registers => @registers)
     else  
       render :text => page_html
     end
      
  end

end