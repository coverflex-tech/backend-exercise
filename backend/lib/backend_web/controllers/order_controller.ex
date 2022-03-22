defmodule BackendWeb.OrderController do
  use BackendWeb, :controller

  action_fallback BackendWeb.FallbackController

  alias Backend.Orders
  alias Backend.Orders.Schemas.Order

  def post(conn, %{"order" => %{"user_id" => user_id, "items" => order_items}}) do
    with {:ok, %Order{} = order} <-
           Orders.create_order(%{user_id: user_id, order_items: order_items}) do
      conn
      |> put_status(:ok)
      |> render("show.json", order: order)
    end
  end
end
