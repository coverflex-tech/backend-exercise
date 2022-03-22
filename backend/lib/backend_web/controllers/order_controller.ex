defmodule BackendWeb.OrderController do
  use BackendWeb, :controller

  alias Backend.Benefits
  alias Backend.Benefits.Order

  action_fallback BackendWeb.FallbackController

  def create(conn, %{"order" => %{"items" => items, "user_id" => user_id}}) do
    with {:ok, %Order{} = order} <- Benefits.create_order(%{items: items, user_id: user_id}) do
      conn
      |> put_status(:created)
      |> render("show.json", order: order)
    end
  end
end
