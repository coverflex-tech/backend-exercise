class ProductSerializer < ActiveModel::Serializer    
  attribute :code, key: :id  
  attributes :name, :price
end
