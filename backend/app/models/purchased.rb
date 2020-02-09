class Purchased < ApplicationRecord
  belongs_to :order, inverse_of: :purchaseds
  belongs_to :product, inverse_of: :purchaseds
end


