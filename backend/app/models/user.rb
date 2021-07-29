class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy
  has_many :order_products, through: :orders

  def products
    self.order_products.map { |order_product| order_product.product }
  end

  def afford?(amount)
    self.balance > amount
  end
end
