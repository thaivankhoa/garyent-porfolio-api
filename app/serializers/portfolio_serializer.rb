class PortfolioSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :total_value,
              :total_invested,
              :gain_or_loss,
              :coins_distribution,
              :created_at,
              :updated_at

  has_many :portfolio_coins

  delegate :gain_or_loss, to: :object

  def total_value
    object.total_value.round(2)
  end

  def total_invested
    object.total_invested.round(2)
  end
end
