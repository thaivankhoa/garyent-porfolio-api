FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { Faker::Name.name }
    confirmed_at { Time.current }

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