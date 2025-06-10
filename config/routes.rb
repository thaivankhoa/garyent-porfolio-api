require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # Enable Sidekiq Web UI
  if defined?(Sidekiq::Web)
    mount Sidekiq::Web => '/sidekiq'
  end

  # mount_devise_token_auth_for 'User', at: 'auth'

  mount_devise_token_auth_for 'User', at: 'api/v1/auth'
  as :user do
    # Define routes for User within this block.
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :coins, only: [:index]

      resources :portfolios do

        resources :coins, controller: 'portfolio_coins', only: [:create, :destroy] do
          member do
            get 'statistics', to: 'portfolio_coins#statistics'
            get 'transactions', to: 'portfolio_coins#transactions'
            post 'add_transaction', to: 'portfolio_coins#add_transactions'
          end
        end

        resources :transactions, only: [:update, :destroy]
      end
    end
  end
end
