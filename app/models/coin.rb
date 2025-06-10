class Coin < ApplicationRecord
  has_many :portfolio_coins, dependent: :destroy
  has_many :portfolios, through: :portfolio_coins

  validates :coingecko_id, presence: true, uniqueness: true
  validates :symbol, presence: true
  validates :name, presence: true
  validates :current_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :market_cap, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :market_cap_rank, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :total_volume, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
