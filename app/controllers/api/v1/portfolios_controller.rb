module Api
  module V1
    class PortfoliosController < Api::V1::Auth::BaseController
      before_action :set_portfolio, only: [:show, :update, :destroy, :statistics, :performance]

      def index
        @portfolios = current_user.portfolios.includes(portfolio_coins: :coin)
        render json: @portfolios, each_serializer: PortfolioSerializer
      end

      def show
        render json: @portfolio, serializer: PortfolioSerializer
      end

      def create
        @portfolio = current_user.portfolios.build(portfolio_params)

        if @portfolio.save
          render json: @portfolio, serializer: PortfolioSerializer, status: :created
        else
          render_error(@portfolio.errors.full_messages.join(", "))
        end
      end

      def update
        if @portfolio.update(portfolio_params)
          render json: @portfolio, serializer: PortfolioSerializer
        else
          render_error(@portfolio.errors.full_messages.join(", "))
        end
      end

      def destroy
        @portfolio.destroy
        head :no_content
      end

      def summary
        summary = current_user.portfolios.map do |portfolio|
          {
            id: portfolio.id,
            name: portfolio.name,
            total_value: portfolio.total_value,
            total_invested: portfolio.total_invested,
            profit_loss: portfolio.profit_loss,
            profit_loss_percentage: portfolio.profit_loss_percentage,
            coins_count: portfolio.portfolio_coins.count
          }
        end

        render json: { summary: summary }
      end

      def statistics
        stats = {
          total_value: @portfolio.total_value,
          total_invested: @portfolio.total_invested,
          profit_loss: @portfolio.profit_loss,
          profit_loss_percentage: @portfolio.profit_loss_percentage,
          coins_distribution: @portfolio.coins_distribution,
          best_performing_coin: @portfolio.best_performing_coin,
          worst_performing_coin: @portfolio.worst_performing_coin
        }

        render json: stats
      end

      def performance
        # Có thể thêm params để filter theo thời gian: 24h, 7d, 30d, 1y
        timeframe = params[:timeframe] || '7d'
        
        data = @portfolio.performance_data(timeframe)
        render json: { performance: data }
      end

      private

      def set_portfolio
        @portfolio = current_user.portfolios.find(params[:id])
      end

      def portfolio_params
        params.require(:portfolio).permit(:name)
      end
    end
  end
end 