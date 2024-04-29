FactoryBot.define do
    factory :card do
        user
        list
        title { Faker::Color.color_name }
    end
end
