FactoryBot.define do
  factory :coin do
    coingecko_id { 'bitcoin' }
    symbol { 'btc' }
    name { 'Bitcoin' }
    current_price { 105000.0 }
    market_cap { 850000000000 }
    market_cap_rank { 1 }
    total_volume { 28000000000 }
    price_change_percentage_24h { 2.5 }
    last_updated { Time.current }

    trait :bitcoin do
      coingecko_id { 'bitcoin' }
      symbol { 'btc' }
      name { 'Bitcoin' }
    end

    trait :ethereum do
      coingecko_id { 'ethereum' }
      symbol { 'eth' }
      name { 'Ethereum' }
      current_price { 2500.0 }
      market_cap { 240000000000 }
      market_cap_rank { 2 }
      total_volume { 15000000000 }
      price_change_percentage_24h { 1.8 }
    end
  end
end 