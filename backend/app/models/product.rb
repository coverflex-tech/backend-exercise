class Product < ApplicationRecord
  has_many :orders, through: :order_products
  has_many :order_products
end
