class AccountsController < ApplicationController

  include ApplicationHelper

  skip_before_filter :require_user, :only => :show
  
  before_filter :require_design, :only => :show
  before_filter :build_registers, :only => :show
  before_filter :set_liquid_variables, :only => :show
  before_filter :require_current_front_page, :only => :show

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @front_page = @account.current_front_page
    
    # Build query of only the necessary ids
    schema_ids = @front_page.schema_article_ids + @front_page.template.required_article_ids
    # One request to find them all
    schema_articles = hash_by_id(Article.find_by_ids(schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id))
    @registers[:widget_data] = @front_page.template.parsed_widget_data(schema_articles)
        
    # Squid reverse proxy caching headers
    expires_in 2.minutes, :public => true
    render :text => @front_page.render(@front_page.sorted_schema_articles(schema_articles).merge('newspaper' => @newspaper, 'current_user' => current_user), :registers => @registers )
  end
end
