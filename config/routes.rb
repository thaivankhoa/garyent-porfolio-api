Rails.application.routes.draw do
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
      resources :coins, only: [:index] do
        # collection do
        #   get 'markets', to: 'coins#markets'  # Lấy market data của tất cả coins
        #   get 'trending', to: 'coins#trending'  # Lấy trending coins
        # end
      end

      resources :portfolios do
        collection do
          get 'summary', to: 'portfolios#summary'  # Tổng quan về tất cả portfolios
        end
        
        member do
          get 'statistics', to: 'portfolios#statistics'  # Thống kê chi tiết của portfolio
          get 'performance', to: 'portfolios#performance'  # Hiệu suất theo thời gian
        end

        resources :coins, controller: 'portfolio_coins', only: [:index, :create, :destroy] do
          member do
            get 'transactions', to: 'portfolio_coins#transactions'  # Lịch sử giao dịch của coin
            get 'statistics', to: 'portfolio_coins#statistics'  # Thống kê của coin trong portfolio
          end
        end

        resources :transactions, only: [:index, :create, :update, :destroy] do
          collection do
            get 'history', to: 'transactions#history'  # Lịch sử giao dịch theo thời gian
            get 'summary', to: 'transactions#summary'  # Tổng hợp giao dịch
          end
        end
      end
    end
  end
end
