# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'uri'
require 'net/http'
require 'json'

puts "Fetching coins data from CoinGecko..."

url = URI("https://api.coingecko.com/api/v3/coins/markets")
params = {
  vs_currency: 'usd',
  page: 1,
  per_page: 100,
  price_change_percentage: '1h,24h,7d'
}
url.query = URI.encode_www_form(params)

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'
request["x-cg-demo-api-key"] = 'CG-UVDmWrh9sxAB27iGAsfvXY2L'

response = http.request(request)
coins_data = JSON.parse(response.body)

puts "Creating/Updating coins..."

coins_data.each do |coin_data|
  coin = Coin.find_or_initialize_by(coingecko_id: coin_data['id'])
  
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
    ath_change_percentage: coin_data['max_suath_change_percentagepply'],
    ath_date: coin_data['ath_date'],
    atl: coin_data['atl'],
    atl_change_percentage: coin_data['atl_change_percentage'],
    atl_date: coin_data['atl_date'],
    price_change_percentage_1h_in_currency: coin_data['price_change_percentage_1h_in_currency'],
    price_change_percentage_24h_in_currency: coin_data['price_change_percentage_24h_in_currency'],
    price_change_percentage_7d_in_currency: coin_data['price_change_percentage_7d_in_currency'],
    last_updated: coin_data['last_updated']
  )
end

puts "Finished seeding #{Coin.count} coins!"

