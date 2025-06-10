class PortfolioCoinSerializer < ActiveModel::Serializer
  attributes  :id,
              :portfolio_id,
              :coin_id,
              :total_quantity,
              :gain_or_loss,
              :coin_data

  def coin_data
    coin = object.coin

    {
      name: coin.name,
      symbol: coin.symbol,
      current_price: coin.current_price,
      market_cap: coin.market_cap,
      price_change_percentage_1h_in_currency: coin.price_change_percentage_1h_in_currency,
      price_change_percentage_24h_in_currency: coin.price_change_percentage_24h_in_currency,
      price_change_percentage_7d_in_currency: coin.price_change_percentage_7d_in_currency,
      image: coin.image
    }
  end
end
