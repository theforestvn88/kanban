FactoryBot.define do
    factory :board do
        user
        name { Faker::Color.color_name }
    end
end
