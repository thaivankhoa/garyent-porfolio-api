module Coingecko
  class MarketService < BaseService
    def fetch_markets(params = {})
      default_params = {
        vs_currency: 'usd',
        page: 1,
        per_page: 100,
        price_change_percentage: '1h,24h,7d'
      }

      final_params = default_params.merge(params)
      Rails.logger.info "Fetching markets with params: #{final_params}"
      
      get('coins/markets', final_params)
    end

    def sync_markets(params = {})
      Rails.logger.info "Starting market sync..."
      coins_data = fetch_markets(params)
      Rails.logger.info "Fetched #{coins_data.size} coins"

      ActiveRecord::Base.transaction do
        coins_data.each do |coin_data|
          coin = Coin.find_or_initialize_by(coingecko_id: coin_data['id'])
          is_new_record = coin.new_record?
          
          coin.update!(
            symbol: coin_data['symbol'],
            name: coin_data['name'],
            image: coin_data['image'],
            current_price: coin_data['current_price'],
            market_cap: coin_data['market_cap'],
            market_cap_rank: coin_data['market_cap_rank'],
            total_volume: coin_data['total_volume'],
            high_24h: coin_data['high_24h'],
            low_24h: coin_data['low_24h'],
            price_change_24h: coin_data['price_change_24h'],
            market_cap_change_24h: coin_data['market_cap_change_24h'],
            market_cap_change_percentage_24h: coin_data['market_cap_change_percentage_24h'],
            circulating_supply: coin_data['circulating_supply'],
            total_supply: coin_data['total_supply'],
            max_supply: coin_data['max_supply'],
            ath: coin_data['ath'],
            ath_change_percentage: coin_data['ath_change_percentage'],
            ath_date: coin_data['ath_date'],
            atl: coin_data['atl'],
            atl_change_percentage: coin_data['atl_change_percentage'],
            atl_date: coin_data['atl_date'],
            price_change_percentage_1h_in_currency: coin_data['price_change_percentage_1h_in_currency'],
            price_change_percentage_24h_in_currency: coin_data['price_change_percentage_24h_in_currency'],
            price_change_percentage_7d_in_currency: coin_data['price_change_percentage_7d_in_currency'],
            last_updated: coin_data['last_updated']
          )

          Rails.logger.info "#{is_new_record ? 'Created' : 'Updated'} coin: #{coin.name} (#{coin.symbol})"
        end
      end

      Rails.logger.info "Finished syncing markets. Total coins: #{Coin.count}"
    end
  end
end 