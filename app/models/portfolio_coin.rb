class PortfolioCoin < ApplicationRecord
  belongs_to :portfolio
  belongs_to :coin
  has_many :transactions, dependent: :destroy

  def total_quantity
    transactions.where(transaction_type: :buy).sum(:quantity) - 
    transactions.where(transaction_type: :sell).sum(:quantity)
  end

  def total_invested
    transactions.where(transaction_type: :buy).sum('quantity * price')
  end

  def average_buy_price
    total_buy_quantity = transactions.where(transaction_type: :buy).sum(:quantity)
    return 0 if total_buy_quantity.zero?
    
    total_invested / total_buy_quantity
  end

  def current_value
    quantity * coin.current_price
  end

  def gain_or_loss
    difference = current_value - total_invested
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
end
