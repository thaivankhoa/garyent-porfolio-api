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
    total_quantity * coin.current_price
  end

  def profit_loss
    current_value - total_invested
  end

  def profit_loss_percentage
    return 0 if total_invested.zero?
    (profit_loss / total_invested) * 100
  end
end
