Rails.application.routes.draw do
  
  namespace :api, defaults: { format: :json } do    
    resources :users, only: [:show]
    resources :products, only: [:index]
    resources :orders, only: [:create]
  end

end
