Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    resources :products, only: [ :index ]
    resources :users, only: [ :show ]
    resources :orders, only: [ :create ]
  end
end
