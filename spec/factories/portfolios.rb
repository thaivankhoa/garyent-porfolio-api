FactoryBot.define do
  factory :portfolio do
    name { Faker::Finance.stock_market }
    description { Faker::Lorem.sentence }
    user

    trait :with_coins do
      after(:create) do |portfolio|
        create_list(:portfolio_coin, 3, portfolio: portfolio)
      end
    end

    trait :empty do
      # Portfolio without any coins
    end
  end
end 