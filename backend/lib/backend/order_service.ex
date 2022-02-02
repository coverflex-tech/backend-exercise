defmodule Backend.OrderService do
  alias Ecto.Multi
  alias Backend.{Orders, Orders.Order, Products, Repo, Users}

  def create_order(user_id, products_ids) do
    Multi.new()
    |> Multi.run(:retrieve_user, retrieve_user(user_id))
    |> Multi.run(:retrieve_products, retrieve_products(products_ids))
    |> Multi.run(:create_order, &new_order/2)
    |> Multi.run(:update_balance, &update_balance/2)
    |> Repo.transaction()
  end

  defp retrieve_user(user_id) do
    fn _repo, _ ->
      Users.get_user_for_update(user_id)
    end
  end

  defp retrieve_products(products_ids) do
    fn _repo, _ ->
      Products.get_products(products_ids)
    end
  end

  defp new_order(_repo, %{retrieve_user: user, retrieve_products: products}) do
    Orders.create_order(user, products)
  end

  defp update_balance(_repo, %{retrieve_user: user, create_order: {order, _}}) do
    new_balance = user.balance - order.total
    Users.update_user(user, %{balance: new_balance})
    IO.inspect(new_balance)
    {:ok, new_balance}
  end
end
