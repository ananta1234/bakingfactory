Rails.application.routes.draw do
  
  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items

  get 'items/:id/new_price' => 'items#new_price', :as => :new_price
  post 'items/:id/create_price' => 'items#create_price', :as => :create_price


  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  resources :users
  resources :sessions
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  get 'cart' => 'cart#show', :as => :show_cart
  get 'items/:id/add_to_cart' => 'cart#add_to_cart', :as => :add_to_cart
  get 'items/:id/remove_from_cart' => 'cart#remove_from_cart', :as => :remove_from_cart
  get 'clear_the_cart' => 'cart#clear_the_cart', :as => :clear_the_cart
  get 'checkout' => 'cart#checkout', :as => :checkout

  #post 'cart' => 'cart#new', :as => :new_cart

  # Set the root url
  root :to => 'home#home'
  
end
