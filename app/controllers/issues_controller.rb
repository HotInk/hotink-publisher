class IssuesController < ApplicationController

  skip_before_filter :require_user
  
  before_filter :set_liquid_variables
  before_filter :find_template
  before_filter :build_registers
  
  def show   
    @issue = Issue.find(params[:id], :params => { :account_id => @account.account_resource_id })
    schema_articles = hash_by_id(Article.find_by_ids(@current_template.required_article_ids, :account_id => @account.account_resource_id))
    @registers[:widget_data] = @current_template.parsed_widget_data(schema_articles)
    render :text => @current_template.render({'issue' => @issue, 'newspaper' => @newspaper, 'current_user' => current_user}, :registers => @registers )
  end
    
  def index  
    @issues = Issue.paginate(:all, :params => { :page => (params[:page] || 1), :per_page => (params[:per_page] || 15), :account_id => @account.account_resource_id })
    schema_articles = hash_by_id(Article.find_by_ids(@current_template.required_article_ids, :account_id => @account.account_resource_id))
    @registers[:widget_data] = @current_template.parsed_widget_data(schema_articles)

    render :text => @current_template.render({'issues' => @issues, 'issues_pagination' => { 'current_page' => @issues.current_page, 'per_page' => @issues.per_page, 'total_entries' => @issues.total_entries },  'newspaper' => @newspaper, 'current_user' => current_user}, :registers => @registers )
  end

end