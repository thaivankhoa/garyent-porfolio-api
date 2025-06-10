module Api
  module V1
    class TransactionsController < Api::V1::Auth::BaseController
      before_action :set_portfolio
      before_action :set_transaction, only: [:update, :destroy]

      def update
        if @transaction.update(transaction_params)
          render json: @transaction
        else
          render json: @transaction.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @transaction.destroy
        head :no_content
      end

      private

      def set_portfolio
        @portfolio = Portfolio.find(params[:portfolio_id])
      end

      def set_transaction
        @transaction = Transaction.joins(portfolio_coin: :portfolio)
                                .where(portfolio_coins: { portfolio_id: @portfolio.id })
                                .find(params[:id])
      end

      def transaction_params
        params.require(:transaction).permit(:quantity, :price, :transaction_type, :transaction_date, :note)
      end
    end
  end
end 