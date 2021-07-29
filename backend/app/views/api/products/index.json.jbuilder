json.array! @products do |product|
  json.product_id product.name.downcase
  json.extract! product, :name
  json.price product.price / 100.0
end
