ActionController::Routing::Routes.draw do |map|

  map.resource :user_session
  map.resources :users
  
  map.resources :accounts, :member => { :take_offline => :post } do |account| # :only => [:index, :issues, :sections, :articles, :blogs, :pages, :comments ]
    account.resources :articles do |article|
      article.resources :comments, :only => [:show, :create, :new] 
      article.resources :mediafile
    end
    account.resources :sections
    account.resources :issues
    account.resources :blogs do |blog|
      blog.resources :entries do |entry|
        entry.resource :comments, :only => [:show, :create] 
        entry.resource :mediafiles
      end      
    end  
    account.resource :feed
    account.resources :podcasts
    account.resources :comments, 
      :member => {:flag => :get, :enable => :get, :disable => :get},
      :collection => { :clear_all_flags => :get, :bulk_action => :post },
      :path_prefix => "accounts/:account_id/admin", :controller => "admin/comments" 
    account.resources :article_options, :collection => { :end_comments => :post, :close_comments => :post, :start_comments => :post }
    account.resource :control_panel
    account.resources :designs do |design|
      design.resources :widgets    
      design.resources :templates
      design.resources :template_files
      
      # Designs have almost the entire public site routing nested beneath
      # to allow for testing of alternate designs
      design.resources :sections
      design.resources :front_pages
      design.resources :articles
      design.resource  :search
      design.resources :pages, :only => :show
    end
    account.resource :design_import
    account.resource :redesigns    
    account.resources :front_pages  
    account.resources :press_runs
    account.resources :pages, :only => [:edit, :index, :create, :new, :destroy, :update]
    account.resource :search
  end
  
  # legacy urls  
  map.connect 'accounts/:account_id/article/:id', :controller => 'articles', :action => 'legacy_show'  
  # map.connect 'accounts/:account_id/:string', :controller => 'redirects', :action => 'lookup'    
  map.connect 'accounts/:account_id/:page_name', :controller=> "pages", :action => "show"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
