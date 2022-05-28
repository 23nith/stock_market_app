Rails.application.routes.draw do
  # get 'current_user/index'
  get '/current_user', to: 'current_user#index'
  resources :stocks
  resources :transactions

  get '/top_ten', to: 'stocks#top_ten'
  post '/stock_info', to: 'stocks#stock_info'

  # devise_for :users
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post '/approve_user' => 'transactions#approve_user', as: 'approve_user'
  get '/traders' => 'users#index'
  
  get '/traders/new' => 'users#new', as: 'admin_create_user'
  post '/traders' => 'users#add_user', as: 'admin_add_user'

  
end
