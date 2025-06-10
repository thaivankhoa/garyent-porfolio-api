FactoryBot.define do
  factory :portfolio_coin do
    portfolio
    coin
    quantity { Faker::Number.decimal(l_digits: 2, r_digits: 8) }
    average_buy_price { Faker::Number.decimal(l_digits: 4, r_digits: 2) }

    trait :with_transactions do
      after(:create) do |portfolio_coin|
        create_list(:transaction, 3, :buy, portfolio_coin: portfolio_coin)
        create_list(:transaction, 2, :sell, portfolio_coin: portfolio_coin)
      end
    end

    trait :only_buys do
      after(:create) do |portfolio_coin|
        create_list(:transaction, 3, :buy, portfolio_coin: portfolio_coin)
      end
    end

    trait :empty do
      # PortfolioCoin without any transactions
    end
  end
end 