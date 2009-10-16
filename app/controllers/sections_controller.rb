require 'uri'

class SectionsController < ApplicationController

  skip_before_filter :require_user, :only => :show
  
  before_filter :require_design, :only => :show
  before_filter :set_liquid_variables, :only => :show
  before_filter :find_template, :only => :show
  before_filter :build_registers, :only => :show
  before_filter :load_widget_data, :only => :show

  def show
    begin
      @section = Section.find(URI.encode(params[:id]), :account_id => @account.account_resource_id, :as => @account.access_token)
    rescue NoMethodError
      zissou
      return
    end
    # We'll get a lot of traffic that thinks it's a section, when really it's a bad request. Give 'em Zissou.
    zissou and return unless @section

    
    @articles = Article.paginate(:all, :page => (params[:page] || 1), :per_page => ( params[:per_page] || 15), :account_id => @account.account_resource_id, :section_id => @section.id, :as => @account.access_token)
    if @articles.first.respond_to?(:current_page) && @articles.first.respond_to?(:article)
      @articles_pagination = { 'current_page' => @articles.first.current_page, 'per_page' => @articles.first.per_page, 'total_entries' => @articles.first.total_entries }
      @articles = @articles.first.article
    else
      @articles_pagination = {}
      @articles = nil
    end
   
    page_html = @current_template.parsed_code.render({'current_section' => @section, 'articles' => @articles.to_a, 'articles_pagination' => @articles_pagination, 'newspaper' => @newspaper}, :registers => @registers )
     if @current_template.current_layout
       render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'current_section' => @section, 'articles' => @articles.to_a, 'article_pagination' => @article_pagination, 'newspaper' => @newspaper}, :registers => @registers)
     else  
       render :text => page_html
     end
      
  end

end