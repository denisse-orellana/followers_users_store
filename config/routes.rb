Rails.application.routes.draw do
  get 'stores/index'
  get 'stores/show'
  get 'user/index'
  get 'user/show'
  devise_for :partners
  devise_for :users
  get 'home/index'
  root "home#index"
  resources :users
  resources :stores

  post '/stores/:id/follow', to: "stores#follow", as: "follow_store"
  post '/stores/:id/unfollow', to: "stores#unfollow", as: "unfollow_store"

  post '/follow/store', to: 'stores#store_follow', as: "store_follow"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
