ActionController::Routing::Routes.draw do |map|

  map.resource :user_session
  map.resources :users

  # TODO: add unRESTful admin dashbouard section
  
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
    account.resources :comments, 
      :member => {:flag => :get, :enable => :get, :disable => :get},
      :collection => { :clear_all_flags => :get, :bulk_action => :post },
      :path_prefix => "accounts/:account_id/admin", :controller => "admin/comments" 
    account.resources :article_options, :collection => { :end_comments => :post, :close_comments => :post, :start_comments => :post }
    account.resource :dashboard
    account.resources :designs do |design|
      design.resources :widgets
      design.resources :sections
      design.resources :front_pages
      design.resources :articles
      design.resources :templates
      design.resources :template_files
    end
    account.resource :redesigns    
    account.resources :front_pages  
    account.resources :press_runs
    account.resources :pages, :only => [:edit, :index, :create, :new, :destroy, :update]
    account.resource :search
  end
  map.connect 'accounts/:account_id/admin', :controller => "admin/pages", :action => "dashboard"
  
  # legacy urls  
  map.connect 'accounts/:account_id/article/:id', :controller => 'articles', :action => 'legacy_show'  
  # map.connect 'accounts/:account_id/:string', :controller => 'redirects', :action => 'lookup'    
  map.connect 'accounts/:account_id/:page_name', :controller=> "pages", :action => "show"
  

# map.resources :photos, :path_prefix => 'admin', :controller => 'admin/photos' 
# map.resources :tags, :name_prefix => 'admin_photo_', :path_prefix => 'admin/photos/:photo_id', :controller => 'admin/photo_tags' 
# map.resources :ratings, :name_prefix => 'admin_photo_', :path_prefix => 'admin/photos/:photo_id', :controller => 'admin/photo_ratings' 

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
