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
    
    # Set registers here 
    @registers[:widget_data] = @current_template.parsed_widget_data(hash_by_id(Article.find_by_ids(@current_template.required_article_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id)))

    @registers[:account] = @account
    @registers[:query] = @search_query
    @registers[:tagged_with] = @tag_query
    @registers[:design] = @current_template.design if @current_template.design
   
    render :text => @current_template.render({'newspaper' => @newspaper, 'search_results' => @search_results.to_a, 'search_results_pagination' => @search_results_pagination, 'search_query' => @search_query, 'tag_query' => @tag_query, 'current_user' => current_user}, :registers => @registers )
  end
  
end
