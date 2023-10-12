Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #auth
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'

  #alerts
  post '/create_alert', to: 'alerts#create'
  put '/update_alert/:id', to: 'alerts#update'
  delete '/delete_alert/:id', to: 'alerts#destroy'
  constraints(page: /\d+/, per_page: /\d+/) do
    get '/list_alerts', to: 'alerts#index'
  end


  get '/*a', to: 'application#not_found'

end
