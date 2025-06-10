class PortfolioCoin < ApplicationRecord
  belongs_to :portfolio
  belongs_to :coin
  has_many :transactions, dependent: :destroy

  def total_quantity
    transactions.inject(0) do |sum, transaction|
      if transaction.buy?
        sum + transaction.quantity
      else
        sum - transaction.quantity
      end
    end
  end

  def total_invested
    transactions.inject(0) do |sum, transaction|
      if transaction.buy?
        sum + (transaction.quantity * transaction.price)
      else
        sum
      end
    end
  end

  def average_buy_price
    buy_transactions = transactions.select(&:buy?)
    total_buy_quantity = buy_transactions.sum(&:quantity)
    return 0 if total_buy_quantity.zero?
    
    total_buy_value = buy_transactions.sum { |t| t.quantity * t.price }
    total_buy_value / total_buy_quantity
  end

  def current_value
    coin.current_price * total_quantity
  end

  def gain_or_loss
    current_val = current_value
    invested = total_invested
    difference = current_val - invested
    
    {
      amount: difference.abs.round(2),
      is_gain: difference >= 0,
      percentage: calculate_gain_loss_percentage(difference, invested)
    }
  end

  private

  def calculate_gain_loss_percentage(difference, invested)
    return 0 if invested.zero?
    
    percentage = (difference / invested * 100).round(2)
    percentage.abs
  end
end
