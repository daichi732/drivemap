Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    resource :likes, only: [:create, :destroy]
  end
  resources :places do
    resource :likes, only: [:create, :destroy]
  end
  root to: 'staticpages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
