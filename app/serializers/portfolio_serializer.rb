class PortfolioSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :total_value,
              :total_invested,
              :gain_or_loss,
              :coins_distribution,
              :created_at,
              :updated_at

  belongs_to :user
  has_many :portfolio_coins

  def gain_or_loss
    object.gain_or_loss
  end

  def total_value
    object.total_value.round(2)
  end

  def total_invested
    object.total_invested.round(2)
  end
end 