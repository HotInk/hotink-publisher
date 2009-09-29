class FeedsController < ApplicationController
  
  skip_before_filter :require_user, :only => :show
  
  def show
    @articles = Article.find(:all, :account_id => @account.account_resource_id, :per_page => 40, :page=>1, :as => @account.access_token)
    if @articles.first.respond_to?(:current_page) && @articles.first.respond_to?(:article)
       @articles_pagination = { 'current_page' => @articles.first.current_page, 'per_page' => @articles.first.per_page, 'total_entries' => @articles.first.total_entries }
       @articles = @articles.first.article
    else
       @articles_pagination = {}
       @articles = nil
    end
    
    @feed_title = (@account.formal_name||@account.name.capitalize) + " news feed"
    @feed_description = "Most recent articles from " + (@account.formal_name||@account.name.capitalize)
    @feed_url = "http://" + request.host_with_port + request.request_uri
    
    response.headers['Content-Type'] = 'application/rss+xml'
           
    respond_to do |format|
      format.xml #show.rxml
    end
  end
  
end
