Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root to: 'staticpages#home'
  resources :users
  resources :places do
    resource :likes, only: [:create, :destroy]
    post '/comments', to: 'comments#create'
    delete '/comments/:id', to: 'comments#destroy'
    # resources :comments, only: [:create, :destroy]
  end
end
