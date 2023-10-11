Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  #auth
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'



  get '/*a', to: 'application#not_found'


  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
