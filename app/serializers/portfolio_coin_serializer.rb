class PortfolioCoinSerializer < ActiveModel::Serializer
  attributes  :id, 
              :total_quantity,
              :average_buy_price,
              :current_value, 
              :total_invested,
              :profit_loss,
              :profit_loss_percentage

  belongs_to :coin

  def total_quantity
    object.total_quantity
  end

  def average_buy_price
    object.average_buy_price
  end

  def current_value
    object.current_value
  end

  def total_invested
    object.total_invested
  end

  def profit_loss
    object.profit_loss
  end

  def profit_loss_percentage
    object.profit_loss_percentage
  end
end 