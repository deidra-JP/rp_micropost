Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  resources :microposts
  devise_for :users
  resources :relationships,       only: [:create, :destroy]
  resources :microposts do
    member do
      get :following_user, :follower_user
    end
  end
end
