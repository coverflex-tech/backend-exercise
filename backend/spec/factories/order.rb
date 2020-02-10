FactoryBot.define do
    factory :order do
        total { rand(-100) }
    end
end