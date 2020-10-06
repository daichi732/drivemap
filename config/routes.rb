Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root to: 'tops#home'
  post '/guest', to: 'sessions#guest_login'

  resources :users do
    resource :likes, only: %i[create destroy]
    member do
      get :following, :followers
    end
  end
  resources :places do
    resource :likes, only: %i[create destroy]
    resources :comments, only: %i[create destroy], shallow: true
    resources :schedules, only: %i[create destroy], shallow: true
  end
  resources :relationships, only: [:create, :destroy]
end
