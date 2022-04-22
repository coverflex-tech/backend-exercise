defmodule BackendWeb.OrderController do
  use BackendWeb, :controller

  alias Backend.Benefits
  alias Backend.Benefits.Order

  action_fallback BackendWeb.FallbackController

  def create(conn, %{"order" => order_params = %{"items" => products}}) do
    with {:ok, %Order{} = order} <- Benefits.create_order(order_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/users/#{order.user_id}")
      |> render("show.json", order: Map.put(order, :products, products))
    end
  end
end
