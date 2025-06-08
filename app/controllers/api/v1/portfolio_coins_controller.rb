module Api
  module V1
    class PortfolioCoinsController < Api::V1::Auth::BaseController
      before_action :set_portfolio
      before_action :set_portfolio_coin, only: [:transactions, :statistics, :destroy]

      def index
        @portfolio_coins = @portfolio.portfolio_coins.includes(:coin)
        render json: @portfolio_coins, each_serializer: PortfolioCoinSerializer
      end

      def create
        @portfolio_coin = @portfolio.portfolio_coins.build(portfolio_coin_params)
        
        if @portfolio_coin.save
          render json: @portfolio_coin, serializer: PortfolioCoinSerializer, status: :created
        else
          render_error(@portfolio_coin.errors.full_messages.join(", "))
        end
      end

      def destroy
        @portfolio_coin.destroy
        head :no_content
      end

      def transactions
        @transactions = @portfolio_coin.transactions.order(transaction_date: :desc)
        render json: @transactions, each_serializer: TransactionSerializer
      end

      def statistics
        stats = {
          total_invested: @portfolio_coin.total_invested,
          current_value: @portfolio_coin.current_value,
          average_buy_price: @portfolio_coin.average_buy_price,
          total_quantity: @portfolio_coin.total_quantity
        }
        
        render json: stats
      end

      private

      def set_portfolio
        @portfolio = current_user.portfolios.find(params[:portfolio_id])
      end

      def set_portfolio_coin
        @portfolio_coin = @portfolio.portfolio_coins.find(params[:id])
      end

      def portfolio_coin_params
        params.require(:portfolio_coin).permit(:coin_id)
      end
    end
  end
end 