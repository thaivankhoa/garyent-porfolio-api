FactoryBot.define do
  factory :coin do
    coingecko_id { 'bitcoin' }
    symbol { 'btc' }
    name { 'Bitcoin' }
    current_price { 45000.0 }
    market_cap { 850000000000 }
    market_cap_rank { 1 }
    total_volume { 28000000000 }
    price_change_percentage_24h { 2.5 }
    sparkline_7d { [44000.0, 44500.0, 45000.0] }
    last_updated { Time.current }

    trait :ethereum do
      coingecko_id { 'ethereum' }
      symbol { 'eth' }
      name { 'Ethereum' }
    end
  end
end 