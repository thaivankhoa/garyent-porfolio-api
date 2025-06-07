class CreateCoins < ActiveRecord::Migration[7.1]
  def change
    create_table :coins do |t|
      t.string     :coingecko_id
      t.string     :symbol
      t.string     :name
      t.string     :image
      t.float      :current_price
      t.float      :market_cap
      t.float      :market_cap_rank
      t.float      :total_volume
      t.float      :high_24h
      t.float      :low_24h
      t.float      :price_change_24h
      t.float      :price_change_percentage_24h
      t.float      :market_cap_change_24h
      t.float      :market_cap_change_percentage_24h
      t.float      :circulating_supply
      t.float      :total_supply
      t.float      :max_supply
      t.float      :ath
      t.float      :ath_change_percentage
      t.string     :ath_date
      t.float      :atl
      t.float      :atl_change_percentage
      t.string     :atl_date
      t.string     :last_updated 
      t.float      :price_change_percentage_1h_in_currency
      t.float      :price_change_percentage_24h_in_currency
      t.float      :price_change_percentage_7d_in_currency
      t.timestamps
    end
  end
end
