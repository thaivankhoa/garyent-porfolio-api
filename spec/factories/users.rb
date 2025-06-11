FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }

    trait :with_portfolio do
      after(:create) do |user|
        create(:portfolio, user: user)
      end
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end 