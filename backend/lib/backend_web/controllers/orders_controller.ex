defmodule BackendWeb.OrdersController do
  use BackendWeb, :controller

  alias Backend.FallbackController
  alias Backend.Orders.Order
  alias Backend.Orders.Services.CreateOrder

  action_fallback FallbackController

  def create(conn, params) do
    case CreateOrder.call(params) do
      {:ok, %Order{} = order} ->
        conn
        |> put_status(200)
        |> render("create.json", order: order)

      {:error, reason} ->
        conn
        |> put_status(400)
        |> render("error.json", order: %{error: reason})
    end
  end
end
