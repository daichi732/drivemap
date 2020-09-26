Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root to: 'tops#home'
  post '/guest', to: 'sessions#guest_login'
  
  resources :users do
    resource :likes, only: [:create, :destroy]
  end
  resources :places do
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy], shallow: true
  end
end
