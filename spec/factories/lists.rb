FactoryBot.define do
    factory :list do
        user
        board
        name { Faker::Color.color_name }
    end
end
