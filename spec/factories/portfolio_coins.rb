FactoryBot.define do
  factory :portfolio_coin do
    portfolio
    coin

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