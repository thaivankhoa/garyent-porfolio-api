class TransactionSerializer < ActiveModel::Serializer
  attributes  :id,
              :portfolio_id,
              :portfolio_coin_id,
              :transaction_type,
              :quantity,
              :price,
              :note,
              :total_value,
              :created_at,
              :transaction_date,
              :coin_data

  def portfolio_id
    object.portfolio_coin.portfolio_id
  end

  def total_value
    (object.quantity * object.price).round(2)
  end

  def coin_data
    coin = object.portfolio_coin.coin
    {
      id: coin.id,
      coingecko_id: coin.coingecko_id,
      name: coin.name,
      symbol: coin.symbol,
      image: coin.image,
      current_price: coin.current_price
    }
  end
end 