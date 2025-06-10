module Api
  module V1
    class CoinsController < Api::V1::Auth::BaseController
      include PaginationConcern

      before_action :authenticate_user!

      def index
        @coins = CoinQuery.new(Coin.all, search_params).call
        latest_updated_at = Coin.maximum(:updated_at)

        render json: paginated_response(@coins, CoinSerializer).merge(
          latest_updated_at: latest_updated_at
        )
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
