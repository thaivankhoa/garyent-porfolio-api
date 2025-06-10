class Coin < ApplicationRecord
  has_many :portfolio_coins, dependent: :destroy
  has_many :portfolios, through: :portfolio_coins
end
