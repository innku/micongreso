Micongreso::Application.routes.draw do
  
  get "activations/create"

  resources :terms
  
  resources :contacts do
    get :deliver, :on => :collection
  end
  
  resources :tags
  resources :cities
  resources :profiles
  resources :regions
  resources :districts
  resources :sittings
  resources :assistances
  resources :views
  
  match '/bill/:bill_id/votes' => 'votes#update', :as => :update_bill_votes
  match '/bill/:bill_id/votes/edit' => 'votes#edit', :as => :edit_bill_votes
  match 'bills/tags/:tag_id' => 'bills#index', :as => :bills_tag
  match 'bills/archive/:month/:year' => 'bills#index', :as => :bills_archive
  
  resources :bills do
    resources :comments, :votes
  end
  
  resources :news do
    resources :comments, :votes
  end
    
  resources :search_members do
    get :group, :on => :collection
  end
  
  resources :states
  resources :parties
  resources :members do
    post :import, :on => :collection
    resources :messages
  end

  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/login' => 'user_sessions#new', :as => :login
  match '/register' => 'users#create', :as => :register
  match '/signup' => 'citizens#new', :as => :signup
  match '/conocenos' => 'dashboard#about', :as => :about_us
  match '/profile' => 'register#profile', :as => :profile
  match '/save_profile' => 'register#save_profile', :as => :save_profile
  match '/notifications' => 'register#notifications', :as => :notifications
  match '/save_notifications' => 'register#save_notifications', :as => :save_notifications
  match '/bienvenido' => 'register#success', :as => :success
  
  resources :password_resets, :only => [ :new, :create, :edit, :update ]
  
  resources :users
  resources :citizens
  resource :user_session
  
  match '/activate/:activation_code' => 'activations#create', :as => :activate
  match '/resend_activation_form' => 'users#resend_form', :as => :resend_activation_form
  match '/resend' => 'users#resend', :as => :resend_activation
  
  root :to => 'dashboard#index'
  
  match '/emails/bill_votes/:id' => 'emails#bill_votes', :as => :email_bill_votes
  match '/emails/bill/:id' => 'emails#bill', :as => :email_bill
end
