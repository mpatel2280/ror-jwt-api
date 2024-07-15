Rails.application.routes.draw do
  resources :posts
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :pets
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  #resources :users, param: :_username
  resources :users
  post '/auth/login', to: 'authentication#login'
  # get '/*a', to: 'application#not_found'

  #Ractor tasks
  get 'ractors/perform_tasks', to: 'ractors#perform_tasks'

  get '/get_concurrent_data', to: "concurrent#get_concurrent_data"

end
