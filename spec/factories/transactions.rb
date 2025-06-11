FactoryBot.define do
  factory :transaction do
    portfolio_coin
    transaction_type { %w[buy sell].sample }
    quantity { Faker::Number.decimal(l_digits: 2, r_digits: 8) }
    price { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    transaction_date { Time.current }
    
    trait :buy do
      transaction_type { 'buy' }
    end
    
    trait :sell do
      transaction_type { 'sell' }
      after(:build) do |transaction|
        # Ensure sell quantity doesn't exceed available balance
        total_bought = transaction.portfolio_coin.transactions.buy.sum(&:quantity)
        total_sold = transaction.portfolio_coin.transactions.sell.sum(&:quantity)
        available = total_bought - total_sold
        transaction.quantity = [transaction.quantity, available].min if available > 0
      end
    end

    trait :recent do
      transaction_date { Time.current - 1.hour }
    end

    trait :old do
      transaction_date { Time.current - 1.month }
    end
  end
end 