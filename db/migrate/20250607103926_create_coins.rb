class CreateCoins < ActiveRecord::Migration[7.1]
  def change
    create_table :coins do |t|
      t.string     :coingecko_id, index: true
      t.string     :symbol, index: true
      t.string     :name
      t.string     :image
      t.decimal    :current_price, precision: 30, scale: 10
      t.decimal    :market_cap, precision: 30, scale: 2
      t.integer    :market_cap_rank
      t.decimal    :total_volume, precision: 30, scale: 2
      t.decimal    :high_24h, precision: 30, scale: 10
      t.decimal    :low_24h, precision: 30, scale: 10
      t.decimal    :price_change_24h, precision: 30, scale: 10
      t.decimal    :price_change_percentage_24h, precision: 10, scale: 2
      t.decimal    :market_cap_change_24h, precision: 30, scale: 2
      t.decimal    :market_cap_change_percentage_24h, precision: 10, scale: 2
      t.decimal    :circulating_supply, precision: 30, scale: 2
      t.decimal    :total_supply, precision: 30, scale: 2
      t.decimal    :max_supply, precision: 30, scale: 2
      t.decimal    :ath, precision: 30, scale: 10
      t.decimal    :ath_change_percentage, precision: 10, scale: 2
      t.datetime   :ath_date
      t.decimal    :atl, precision: 30, scale: 10
      t.decimal    :atl_change_percentage, precision: 10, scale: 2
      t.datetime   :atl_date
      t.datetime   :last_updated
      t.decimal    :price_change_percentage_1h_in_currency, precision: 10, scale: 2
      t.decimal    :price_change_percentage_24h_in_currency, precision: 10, scale: 2
      t.decimal    :price_change_percentage_7d_in_currency, precision: 10, scale: 2
      t.timestamps
    end
  end
end
