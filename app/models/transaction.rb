class Transaction < ApplicationRecord
  belongs_to :portfolio_coin

	enum transaction_type: { buy: 0, sell: 1, transfer: 2 }
end
