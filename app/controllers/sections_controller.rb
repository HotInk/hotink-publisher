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
      @section = Section.find(URI.encode(params[:id]).gsub('&', '%26'), :params => { :account_id => @account.account_resource_id })
    rescue NoMethodError
      zissou
      return
    end
    # We'll get a lot of traffic that thinks it's a section, when really it's a bad request. Give 'em Zissou.
    zissou and return unless @section

    page = params[:page] || 1
    per_page = params[:per_page] || 15
    @articles = Article.paginate(:all, :params => { :page => page, :per_page => per_page, :account_id => @account.account_resource_id, :section_id => @section.id })
    @articles_pagination = { 'current_page' => @articles.current_page, 'per_page' => @articles.per_page, 'total_entries' => @articles.total_entries }

    render :text => @current_template.render({'current_section' => @section, 'articles' => @articles.to_a, 'articles_pagination' => @articles_pagination, 'newspaper' => @newspaper, 'current_user' => current_user}, :registers => @registers)
  end

end