json.array! @products do |product|
  json.product_id product.name.downcase
  json.extract! product, :name, :price
end
