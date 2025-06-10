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
      Rails.logger.info 'Starting market sync...'
      coins_data = fetch_markets(params)
      Rails.logger.info "Fetched #{coins_data.size} coins"

      ActiveRecord::Base.transaction do
        coins_data.each { |coin_data| update_or_create_coin(coin_data) }
      end

      Rails.logger.info 'Market sync completed successfully!'
    rescue StandardError => e
      Rails.logger.error "Error syncing markets: #{e.message}"
      raise e
    end

    private

    def update_or_create_coin(coin_data)
      coin = Coin.find_or_initialize_by(coingecko_id: coin_data['id'])
      update_coin_attributes(coin, coin_data)
      log_coin_update(coin)
    end

    def update_coin_attributes(coin, data)
      coin.assign_attributes(
        basic_attributes(data)
          .merge(market_attributes(data))
          .merge(price_history_attributes(data))
          .merge(supply_attributes(data))
          .merge(price_change_attributes(data))
      )
      coin.save!
    end

    def basic_attributes(data)
      {
        symbol: data['symbol'],
        name: data['name'],
        image: data['image'],
        current_price: data['current_price'],
        last_updated: data['last_updated']
      }
    end

    def market_attributes(data)
      {
        market_cap: data['market_cap'],
        market_cap_rank: data['market_cap_rank'],
        total_volume: data['total_volume'],
        market_cap_change_24h: data['market_cap_change_24h'],
        market_cap_change_percentage_24h: data['market_cap_change_percentage_24h']
      }
    end

    def price_history_attributes(data)
      {
        high_24h: data['high_24h'],
        low_24h: data['low_24h'],
        price_change_24h: data['price_change_24h'],
        price_change_percentage_24h: data['price_change_percentage_24h']
      }
    end

    def supply_attributes(data)
      {
        circulating_supply: data['circulating_supply'],
        total_supply: data['total_supply'],
        max_supply: data['max_supply']
      }
    end

    def price_change_attributes(data)
      {
        ath: data['ath'],
        ath_change_percentage: data['ath_change_percentage'],
        ath_date: data['ath_date'],
        atl: data['atl'],
        atl_change_percentage: data['atl_change_percentage'],
        atl_date: data['atl_date'],
        price_change_percentage_1h_in_currency: data['price_change_percentage_1h_in_currency'],
        price_change_percentage_24h_in_currency: data['price_change_percentage_24h_in_currency'],
        price_change_percentage_7d_in_currency: data['price_change_percentage_7d_in_currency']
      }
    end

    def log_coin_update(coin)
      action = coin.previously_new_record? ? 'Created' : 'Updated'
      Rails.logger.info "#{action} coin: #{coin.name} (#{coin.symbol})"
    end
  end
end
