class Order < ApplicationRecord

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true

  belongs_to :user
  has_many :purchaseds  
  has_many :products, through: :purchaseds
  
end
