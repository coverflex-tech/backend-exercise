class Balance < ApplicationRecord

    validates :user_id, presence: true
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

    belongs_to :user
end
