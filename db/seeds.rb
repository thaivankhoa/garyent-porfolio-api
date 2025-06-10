# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Fetching and syncing coins data from CoinGecko..."

begin
  market_service = Coingecko::MarketService.new
  params = {
		vs_currency: 'usd',
		page: 1,
		per_page: 200,
		price_change_percentage: '1h,24h,7d'
	}

  market_service.sync_markets(params)
  puts "Finished seeding #{Coin.count} coins!"
rescue Coingecko::BaseService::RateLimitError => e
  puts "Rate limit exceeded: #{e.message}"
rescue Coingecko::BaseService::ApiError => e
  puts "API error: #{e.message}"
rescue Coingecko::BaseService::ConnectionError => e
  puts "Connection error: #{e.message}"
rescue Coingecko::BaseService::Error => e
  puts "Unknown error: #{e.message}"
end

