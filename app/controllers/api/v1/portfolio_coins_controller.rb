module Api
  module V1
    class PortfolioCoinsController < Api::V1::Auth::BaseController
      include PaginationConcern

      before_action :set_portfolio
      before_action :set_portfolio_coin, except: [:create]

      def create
        @portfolio_coin = @portfolio.portfolio_coins.find_or_initialize_by(coin_id: coin_params[:coin_id])

        if @portfolio_coin.save
          render json: @portfolio_coin, serializer: PortfolioCoinSerializer, status: :created
        else
          render json: { errors: @portfolio_coin.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @portfolio_coin.destroy
        head :no_content
      end

      def statistics
        stats = {
          total_invested: @portfolio_coin.total_invested,
          current_value: @portfolio_coin.current_value,
          gain_or_loss: @portfolio_coin.gain_or_loss,
          total_quantity: @portfolio_coin.total_quantity,
          average_buy_price: @portfolio_coin.average_buy_price,
          current_price: @portfolio_coin.coin.current_price,
          price_change_percentage_24h_in_currency: @portfolio_coin.coin.price_change_percentage_24h_in_currency,
          transactions_count: @portfolio_coin.transactions.count,
          first_transaction_date: @portfolio_coin.transactions.minimum(:created_at),
          last_transaction_date: @portfolio_coin.transactions.maximum(:created_at)
        }

        render json: stats
      end

      def transactions
        @transactions = TransactionQuery.new(
          @portfolio_coin.transactions,
          search_transaction_params
        ).call

        render json: paginated_response(@transactions, TransactionSerializer)
      end

      def add_transactions
        @transaction = @portfolio_coin.transactions.build(create_transaction_params)

        if @transaction.save
          render json: @transaction, status: :created
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update_transactions
        @transaction = @portfolio_coin.transactions.find(params[:transaction_id])

        if @transaction.update(create_transaction_params)
          render json: @transaction
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def remove_transactions
        @transaction = @portfolio_coin.transactions.find(params[:transaction_id])
        @transaction.destroy
        head :no_content
      end

      private

      def set_portfolio
        @portfolio = current_user.portfolios.find(params[:portfolio_id])
      end

      def set_portfolio_coin
        @portfolio_coin = @portfolio.portfolio_coins.find(params[:id])
      end

      def coin_params
        params.require(:portfolio_coin).permit(:coin_id)
      end

      def create_transaction_params
        params.require(:transaction).permit(
          :transaction_type,
          :quantity,
          :price,
          :note,
          :transaction_date
        )
      end

      def search_transaction_params
        params.permit(
          :portfolio_id, :id, :page, :per_page,
          filter: %i[transaction_type start_date end_date],
          order: %i[column direction]
        )
      end
    end
  end
end
