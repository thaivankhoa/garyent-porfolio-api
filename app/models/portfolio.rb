class Portfolio < ApplicationRecord
  belongs_to :user
	has_many :transactions, dependent: :destroy
	has_many :portfolio_coins, dependent: :destroy
end
