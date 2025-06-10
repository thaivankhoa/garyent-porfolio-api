class Transaction < ApplicationRecord
  belongs_to :portfolio_coin

  enum transaction_type: { buy: 0, sell: 1, transfer: 2 }

  validates :transaction_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_date, presence: true
  validates :portfolio_coin_id, presence: true
  validate :sufficient_balance_for_sell, if: :sell?

  # Scopes
  scope :buys, -> { where(transaction_type: :buy) }
  scope :sells, -> { where(transaction_type: :sell) }
  scope :recent_first, -> { order(transaction_date: :desc) }
  scope :by_date_range, ->(start_date, end_date) { where(transaction_date: start_date..end_date) }

  before_validation :set_default_transaction_date

  private

  def set_default_transaction_date
    self.transaction_date ||= Time.current
  end

  def sufficient_balance_for_sell
    return unless sell?
    return if new_record? && portfolio_coin.total_quantity >= quantity
    return if persisted? && portfolio_coin.total_quantity + quantity_was >= quantity

    errors.add(:quantity, 'exceeds available balance')
  end
end
