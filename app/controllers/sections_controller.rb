require 'uri'

class SectionsController < ApplicationController

  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables, :only => :show
  before_filter :find_template, :only => :show

  before_filter :build_registers, :only => :show

  def show
    @section = Section.find(URI.encode(params[:id]), :account_id => @account.account_resource_id, :as => @account.access_token)
    
    # We'll get a lot of traffic that thinks it's a section, when really it's a bad request. Give 'em Zissou.
    zissou unless @section

    
    @articles = Article.paginate(:all, :page => (params[:page] || 1), :per_page => ( params[:per_page] || 15), :account_id => @account.account_resource_id, :section_id => @section.id, :as => @account.access_token)
    @article_pagination = { :current_page => @articles.current_page, :per_page => @articles.per_page, :total_entries => @articles.total_entries }
    
      # Widget data processing -- start  
      # Build query of only the necessary ids, from the widgets      
      schema_ids = Array.new
      found_widgets = @current_template.widgets
      found_widgets += @current_template.current_layout.widgets if @current_template.current_layout
      found_widgets.each do |widget|
        widget.schema.each_key do |item|
          schema_ids += widget.schema[item]['ids']
        end
      end

      unless schema_ids.blank?  
        article_resources = Article.find(:all, :ids => schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id, :as => @account.access_token)

        widget_data = {}
        schema_articles = {}

        article_resources.each do |article|
           schema_articles.merge!(article.id.to_s => article)
        end

        found_widgets.each do |widget|
          widget.schema.each_key do |item|
            item_array = widget.schema[item]['ids'].collect{ |i| schema_articles[i] }
            widget_data.merge!( "#{item}_#{widget.name}" => item_array )
          end
        end

        # Set registers here 
        @registers[:widget_data] = widget_data
      end
      # Widget data processing -- end

    @registers[:account] = @account
    @registers[:design] = @current_template.design if @current_template.design
   
    page_html = @current_template.parsed_code.render({'current_section' => @section, 'articles' => @articles.to_a, 'article_pagination' => @article_pagination, 'newspaper' => @newspaper}, :registers => @registers )
     if @current_template.current_layout
       render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'current_section' => @section, 'articles' => @articles.to_a, 'article_pagination' => @article_pagination, 'newspaper' => @newspaper}, :registers => @registers)
     else  
       render :text => page_html
     end
      
  end

end