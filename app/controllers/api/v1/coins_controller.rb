module Api
  module V1
    class CoinsController < Api::V1::BaseController
      def index
        @coins = Coin.order(market_cap_rank: :asc)
                    .page(params[:page] || 1)
                    .per(params[:per_page] || 20)

        render json: {
          coins: ActiveModel::Serializer::CollectionSerializer.new(@coins, serializer: CoinSerializer),
          meta: PaginationMetaSerializer.new(@coins)
        }
      end
    end
  end
end
