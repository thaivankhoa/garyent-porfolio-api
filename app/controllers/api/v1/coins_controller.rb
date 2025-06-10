module Api
  module V1
    class CoinsController < Api::V1::Auth::BaseController
      before_action :authenticate_user!

      def index
        @coins = CoinQuery.new(Coin.all, search_params).call
        render json: {
          coins: ActiveModel::Serializer::CollectionSerializer.new(@coins, serializer: CoinSerializer),
          meta: {
            current_page: @coins.current_page,
            total_pages: @coins.total_pages,
            total_count: @coins.total_count,
            per_page: @coins.limit_value
          }
        }
      end

      def show
        @coin = Coin.find(params[:id])
        render json: @coin
      end

      private

      def search_params
        params.permit(:search, :page, :per_page)
      end
    end
  end
end
