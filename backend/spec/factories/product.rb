FactoryBot.define do
    factory :product do
        code { Faker::Alphanumeric.alpha(number: 10).downcase }
        name { Faker::Company.name }
        price { rand(-100) }
    end
end