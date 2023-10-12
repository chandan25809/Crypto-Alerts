Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #auth
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'

  #alerts
  post '/:_username/create_alert', to: 'alerts#create'
  put '/:_username/update_alert/:id', to: 'alerts#update'
  delete '/:_username/delete_alert/:id', to: 'alerts#destroy'
  constraints(page: /\d+/, per_page: /\d+/) do
    get '/:_username/list_alerts', to: 'alerts#index'
  end


  get '/*a', to: 'application#not_found'


  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
