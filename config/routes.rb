Rails.application.routes.draw do

  root 'static_pages#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  post 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  get '/login', to: 'sessions#new'
  get 'auth/identity/', to: redirect('/login')
  resources :identities, only: [:new, :create]
  
  get '/add-a-book', to: 'books#new'
  post '/add-a-book', to: 'books#new'

  get '/explore', to: 'users#index'
  
  post 'read', to: 'user_books#create'
  post 'delete_book', to: 'user_books#destroy'


  resources :books, only: [:create]

  resources :users, except: [:index, :destroy] do  
    member do
      resources :relationships, only: [:create, :destroy]
      get :following, :followers
    end
  end
  
end
