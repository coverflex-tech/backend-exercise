json.user do
  json.user_id @user.username

  json.data do
    json.balance @user.balance / 100.00
    json.product_ids @product_names
  end
end
