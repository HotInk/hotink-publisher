class FeedsController < ApplicationController
  
  skip_before_filter :require_user, :only => :show
  
  def show
    @articles = Article.paginate(:params => {:account_id => @account.account_resource_id, :per_page => 40, :page=>1 })
    @articles_pagination = { 'current_page' => @articles.current_page, 'per_page' => @articles.per_page, 'total_entries' => @articles.total_entries }
    
    @feed_title = (@account.formal_name||@account.name.capitalize) + " main article feed"
    @feed_description = "Most recent articles from " + (@account.formal_name||@account.name.capitalize)
    @feed_url = "http://" + request.host_with_port + request.request_uri
    
    response.headers['Content-Type'] = 'application/rss+xml'
     
    # Squid caching headers
    expires_in 10.minutes, :public => true
          
    respond_to do |format|
      format.xml #show.rxml
    end
  end
  
end
