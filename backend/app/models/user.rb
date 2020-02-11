class User < ApplicationRecord

    validates :username, presence: true
    validates :username, uniqueness: { case_sensitive: true }      
    
    has_many :balances
    has_many :orders

    # QUESTION: There appears to be a bug in the callback from the API where
    # the balance, no matter how many products, always comes back as 500.
    # Wonder if this could be the culprit.
    after_create do
        self.balances.create!(amount: 500)
    end
    
end
