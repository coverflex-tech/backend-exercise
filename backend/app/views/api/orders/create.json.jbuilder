json.order do
  json.order_id @order.id
  json.data do
    json.items @product_names
    json.total @order.total / 100.0
  end
end
