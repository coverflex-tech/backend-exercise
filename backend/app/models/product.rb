class Product < ApplicationRecord

    validates :code, uniqueness: { case_sensitive: true }
    validates :name, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true    

    has_many :purchaseds
    has_many :orders, through: :purchaseds    
end
