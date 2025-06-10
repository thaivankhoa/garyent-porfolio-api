FactoryBot.define do
  factory :coin do
    coingecko_id { Faker::Crypto.md5 }
    symbol { Faker::Currency.code.downcase }
    name { Faker::CryptoCoins.coin }
    current_price { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    market_cap { Faker::Number.number(digits: 12) }
    market_cap_rank { Faker::Number.between(from: 1, to: 1000) }
    total_volume { Faker::Number.number(digits: 10) }
    price_change_percentage_24h_in_currency { Faker::Number.between(from: -10.0, to: 10.0) }
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
    end
  end
end 