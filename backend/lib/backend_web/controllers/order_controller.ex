defmodule BackendWeb.OrderController do
  use BackendWeb, :controller

  alias Backend.{Orders, Orders.Order, Products, Users}

  action_fallback(BackendWeb.FallbackController)

  def create(conn, %{"order" => order_params}) do
    with {:ok, products_ids} <- get_uniq_product_ids(order_params),
         {:ok, user_id} <- get_user_id(order_params),
         {:ok, user} <- Users.get_user(user_id),
         {:ok, products} <- Products.get_products(products_ids),
         {:ok, {order, items}} <- Orders.create_order(user, products) do
      conn
      |> put_status(:ok)
      |> render("show.json", order: order, items: items)
    end
  end

  defp get_uniq_product_ids(%{"items" => ids_list}) do
    uniq_ids =
      ids_list
      |> MapSet.new()
      |> MapSet.to_list()

    {:ok, uniq_ids}
  end

  defp get_uniq_product_ids(_), do: {:error, "no_products_list_supplied"}

  defp get_user_id(%{"user_id" => user_id}), do: {:ok, user_id}
  defp get_user_id(_), do: {:error, "no_user_id_supplied"}
end
