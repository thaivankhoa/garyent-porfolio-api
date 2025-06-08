class PortfolioSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :total_value,
              :total_invested,
              :profit_loss,
              :profit_loss_percentage,
              :created_at,
              :updated_at

  has_many :portfolio_coins
end 