FactoryBot.define do
    factory :user do
        username { Faker::Alphanumeric.alpha(number: 10).downcase }      
    end
end