# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  
  root "products#index"
  
  resources :products, only: [:index, :show]
  resources :cart_items, only: [:create, :update, :destroy]
  resources :carts, only: [:show]
  
  get 'checkout', to: 'checkouts#new'
  post 'checkout', to: 'checkouts#create'
end