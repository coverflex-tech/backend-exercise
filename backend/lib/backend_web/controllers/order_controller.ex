defmodule BackendWeb.OrderController do
  use BackendWeb, :controller

  alias Backend.OrderService

  action_fallback(BackendWeb.FallbackController)

  def create(conn, %{"order" => order_params}) do
    with {:ok, products_ids} <- get_uniq_product_ids(order_params),
         {:ok, user_id} <- get_user_id(order_params),
         {:ok, %{create_order: {order, items}}} <-
           OrderService.create_order(user_id, products_ids) do
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
