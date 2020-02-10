class User < ApplicationRecord

    validates :username, presence: true
    validates :username, uniqueness: { case_sensitive: true }      
    
    has_many :balances
    has_many :orders

    after_create do
        self.balances.create!(amount: 500)
    end
    
end
