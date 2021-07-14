json.order do
  json.order_id @order.id
  json.data do
    json.items "list product names here"
    json.total @order.total
  end
end
