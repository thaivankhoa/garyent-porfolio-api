module Api
  module V1
    class PortfoliosController < Api::V1::Auth::BaseController
      before_action :set_portfolio, only: [:show, :update, :destroy]

      def index
        @portfolios = current_user.portfolios.includes(portfolio_coins: [:coin, :transactions])
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
          render json: @portfolio.errors, status: :unprocessable_entity
        end
      end

      def update
        if @portfolio.update(portfolio_params)
          render json: @portfolio, serializer: PortfolioSerializer
        else
          render json: @portfolio.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @portfolio.destroy
        head :no_content
      end

      private

      def set_portfolio
        @portfolio =
          current_user
            .portfolios
            .includes(portfolio_coins: [:coin, :transactions])
            .find(params[:id])
      end

      def portfolio_params
        params.require(:portfolio).permit(:name)
      end
    end
  end
end 