class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :portfolio_coins, dependent: :destroy

  validates :name, presence: true

  def total_value
    portfolio_coins.sum(&:current_value)
  end

  def total_invested
    portfolio_coins.sum(&:total_invested)
  end

  def gain_or_loss
    difference = total_value - total_invested
    {
      amount: difference.abs.round(2),
      is_gain: difference >= 0,
      percentage: calculate_gain_loss_percentage(difference)
    }
  end

  private

  def calculate_gain_loss_percentage(difference)
    return 0 if total_invested.zero?

    percentage = (difference / total_invested * 100).round(2)
    percentage.abs
  end

  def coins_distribution
    total = total_value
    return [] if total.zero?

    distribution = portfolio_coins.map do |pc|
      {
        coin_id: pc.coin_id,
        symbol: pc.coin.symbol,
        name: pc.coin.name,
        value: pc.current_value,
        percentage: (pc.current_value / total * 100).round(2)
      }
    end
    distribution.sort_by { |coin| -coin[:value] }
  end

  def best_performing_coin
    portfolio_coins.max_by { |pc| pc.gain_or_loss[:percentage] }
  end

  def worst_performing_coin
    portfolio_coins.min_by { |pc| pc.gain_or_loss[:percentage] }
  end

  def performance_data(_timeframe)
    {
      labels: [],
      values: []
    }
  end
end
