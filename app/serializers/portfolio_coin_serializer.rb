class PortfolioCoinSerializer < ActiveModel::Serializer
  attributes :id,
    :portfolio_id,
    :coin_id,
    :quantity,
    :current_value,
    :total_invested,
    :gain_or_loss,
    :created_at,
    :updated_at

  belongs_to :portfolio
  belongs_to :coin

  def current_value
    object.current_value.round(2)
  end

  def total_invested
    object.total_invested.round(2)
  end

  def gain_or_loss
    object.gain_or_loss
  end
end 