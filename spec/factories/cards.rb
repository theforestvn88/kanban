FactoryBot.define do
    factory :card do
        user
        board
        list
        title { Faker::Color.color_name }
    end
end
