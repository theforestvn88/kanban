FactoryBot.define do
    sequence(:email) { |n| "person#{n}@example.com" }

    factory :user do
        email { generate(:email) }
        password { Faker::Internet.password }
    end
end
