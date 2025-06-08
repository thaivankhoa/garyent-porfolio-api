class Portfolio < ApplicationRecord
  belongs_to :user
	has_many :transactions, dependent: :destroy
	has_many :portfolio_coins, dependent: :destroy
	has_many :coins, through: :portfolio_coins

  validates :name, presence: true

  def total_value
    portfolio_coins.sum(&:current_value)
  end

  def total_invested
    portfolio_coins.sum(&:total_invested)
  end

  def profit_loss
    total_value - total_invested
  end

  def profit_loss_percentage
    return 0 if total_invested.zero?
    (profit_loss / total_invested) * 100
  end

  def coins_distribution
    total = total_value
    return [] if total.zero?

    portfolio_coins.map do |pc|
      {
        coin_id: pc.coin_id,
        symbol: pc.coin.symbol,
        name: pc.coin.name,
        value: pc.current_value,
        percentage: (pc.current_value / total * 100).round(2)
      }
    end.sort_by { |coin| -coin[:value] }
  end

  def best_performing_coin
    portfolio_coins.max_by(&:profit_loss_percentage)
  end

  def worst_performing_coin
    portfolio_coins.min_by(&:profit_loss_percentage)
  end

  def performance_data(timeframe)
    {
      labels: [],
      values: []
    }
  end
end
