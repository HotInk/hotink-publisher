class SearchesController < ApplicationController
  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables, :only => :show
  before_filter :find_template, :only => :show

  before_filter :build_registers, :only => :show
  
  def show    
    @search_query = params[:q]
    @search_results = Article.paginate(:all, :from => "/accounts/#{@account.account_resource_id.to_s}/search.xml", :params => { :only => "articles", :q => @search_query, :page => (params[:page] || 1), :per_page => ( params[:per_page] || 15) }, :as => @account.access_token )
    unless @search_results.first.total_entries == 0
      @search_results_pagination = { :current_page => @search_results.first.current_page, :per_page => @search_results.first.per_page, :total_entries => @search_results.first.total_entries }
      @search_results = @search_results.first.article
    else
      @search_results_pagination = {}
      @search_results = []
    end
    
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
   
    page_html = @current_template.parsed_code.render({'newspaper' => @newspaper, 'search_results' => @search_results.to_a, 'search_results_pagination' => @search_results_pagination, 'search_query' => @search_query}, :registers => @registers )
     if @current_template.current_layout
       render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'search_results' => @sarch_results.to_a, 'search_results_pagination' => @search_results_pagination, 'search_query' => @search_query, 'newspaper' => @newspaper}, :registers => @registers)
     else  
       render :text => page_html
     end   
  end
  
end
