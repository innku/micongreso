ActionController::Routing::Routes.draw do |map|
  map.resources :contacts, :collection => {:deliver => :any}

  map.resources :tags

  map.resources :cities

  map.resources :profiles

  map.resources :regions
  map.resources :districts

  map.resources :sittings
  map.resources :absences
  map.resources :views
  
  map.update_bill_votes '/bill/:bill_id/votes', :controller => 'votes', :action => 'update'
  map.edit_bill_votes '/bill/:bill_id/votes/edit', :controller => 'votes', :action => 'edit'
  map.resources :bills, :has_many => [:comments, :votes]
  map.resources :news, :has_many => [:comments, :votes]
  
  map.bills_tag 'bills/tags/:tag_id', :controller => 'bills', :action => 'index'
  map.bills_archive 'bills/archive/:month/:year', :controller => 'bills', :action => 'index'
    
  map.resources :search_members, :collection => {:group => :get}
  map.resources :states
  map.resources :parties
  map.resources :members, :collection => {:import => :post}, :has_many => :messages

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'citizens', :action => 'new'
  map.about_us '/conocenos', :controller => 'dashboard', :action => "about"
  map.forgot_form '/forgot_form', :controller => 'users', :action => 'forgot_form'
  map.forgot_password '/forgot', :controller => 'users', :action => 'forgot'
  
  map.resources :users
  map.resources :citizens
  map.resource :session
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.resend_activation_form '/resend_activation_form', :controller => 'users', :action => 'resend_form'
  map.resend_activation '/resend', :controller => 'users', :action => 'resend'
  
  map.root :controller => "dashboard", :action => "index"
  
  map.email_bill_votes '/emails/bill_votes/:id', :controller => 'emails', :action => 'bill_votes'
  map.email_bill '/emails/bill/:id', :controller => 'emails', :action => 'bill'

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
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
