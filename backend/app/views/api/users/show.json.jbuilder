json.user do
  json.user_id @user.username

  json.data do
    json.balance @user.balance
    json.product_ids @product_names
  end
end
