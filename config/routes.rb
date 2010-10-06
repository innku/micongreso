Micongreso::Application.routes.draw do

  namespace :admin do
    resources :bills do
      resources :actions
    end
    resources :parties
    resources :sittings
    resources :states
    resources :tags
    resources :terms
    resources :users
  end
  
  resources :cities
  resources :regions
  resources :districts
  
  resources :contacts do
    post :deliver, :on => :collection
  end
  
  match '/bill/:bill_id/votes' => 'votes#update', :as => :update_bill_votes
  match '/bill/:bill_id/votes/edit' => 'votes#edit', :as => :edit_bill_votes
  match 'bills/tags/:tag_id' => 'bills#index', :as => :bills_tag
  match 'bills/archive/:month/:year' => 'bills#index', :as => :bills_archive
  
  resources :bills do
    resources :comments, :votes, :actions
  end
  
  resources :news do
    resources :comments, :votes
  end
  
  resources :comments do
    resources :votes
  end
    
  resources :search_members do
    get :group, :on => :collection
  end
  
  resources :members do
    post :import, :on => :collection
    resources :messages do
      get :success, :on => :member
    end
  end

  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/login' => 'user_sessions#new', :as => :login
  match '/register' => 'users#create', :as => :register
  match '/signup' => 'users#new', :as => :signup
  match '/conocenos' => 'dashboard#about', :as => :about_us
  match '/profile' => 'register#profile', :as => :profile
  match '/save_profile' => 'register#save_profile', :as => :save_profile
  match '/notifications' => 'register#notifications', :as => :notifications
  match '/save_notifications' => 'register#save_notifications', :as => :save_notifications
  match '/bienvenido' => 'register#success', :as => :success
  
  resources :password_resets, :only => [ :new, :create, :edit, :update ]
  
  resources :users
  resource :user_session
  
  match '/activate/:activation_code' => 'activations#create', :as => :activate
  match '/resend_activation_form' => 'users#resend_form', :as => :resend_activation_form
  match '/resend' => 'users#resend', :as => :resend_activation
  
  root :to => 'dashboard#index'
  
  match '/emails/bill_votes/:id' => 'emails#bill_votes', :as => :email_bill_votes
  match '/emails/bill/:id' => 'emails#bill', :as => :email_bill
end
