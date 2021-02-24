defmodule BackendWeb.OrdersController do
  use BackendWeb, :controller

  def create(conn, %{"order" => %{"items" => items, "user_id" => user_id}}) do
    case Backend.Order.create(user_id, items) do
      {:ok, order} -> json(conn, %{order: order})
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end
end
