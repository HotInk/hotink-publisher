class SearchesController < ApplicationController
  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables, :only => :show
  before_filter :find_template, :only => :show

  before_filter :build_registers, :only => :show
  
  def show    
    @search_query = params[:q]
    @tag_query = params[:tagged_with]
    page = params[:page] || 1
    per_page = params[:per_page] || 15
    
    if @search_query
      @search_results = Article.paginate(:params => { :search => @search_query, :account_id => @account.account_resource_id.to_s, :page => page, :per_page => per_page } )
    else
      @search_results = Article.paginate(:params => { :tagged_with => @tag_query, :account_id => @account.account_resource_id.to_s, :page => page, :per_page => per_page } )
    end
  
    @search_results_pagination = { 'current_page' => @search_results.current_page, 'per_page' => @search_results.per_page, 'total_entries' => @search_results.total_entries }
    
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
      article_resources = Article.find_by_ids(schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id)

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
    @registers[:query] = @search_query
    @registers[:tagged_with] = @tag_query
    @registers[:design] = @current_template.design if @current_template.design
   
    render :text => @current_template.render({'newspaper' => @newspaper, 'search_results' => @search_results.to_a, 'search_results_pagination' => @search_results_pagination, 'search_query' => @search_query, 'tag_query' => @tag_query, 'current_user' => current_user}, :registers => @registers )
  end
  
end
