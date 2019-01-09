require 'sidekiq/web'

Rails.application.routes.draw do

  namespace :manage do
    mount Sidekiq::Web => '/sidekiq'
    Sidekiq::Web.set :session_secret, Rails.application.credentials.dig(:secret_key_base)
  end

  resource :top
  resource :new
  resource :show
  resource :ask
  resource :job
  resources :items, only: [:show]
  get "/user/:id" => "users#show", as: :user

  get '/service-worker.js' => "service_worker#service_worker"
  get '/manifest.json' => "service_worker#manifest"
  root "tops#show"
end
