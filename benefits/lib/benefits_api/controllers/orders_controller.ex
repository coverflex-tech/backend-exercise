defmodule BenefitsAPI.OrdersController do
  @moduledoc false

  use BenefitsAPI, :controller

  alias BenefitsAPI.OrdersView

  def create(conn, %{"order" => order}) do
    with {:ok, input} <- validate(order, Benefits.Orders.CreateOrderInput),
         {:ok, order} <- Benefits.create_order(input) do
      conn
      |> put_view(OrdersView)
      |> render("order.json", %{order: order})
    else
      {:error, reason}
      when reason in [:insufficient_balance, :products_already_purchased, :products_not_found] ->
        conn
        |> put_view(ErrorView)
        |> put_status(:bad_request)
        |> render("client_error.json", %{reason: reason})
    end
  end
end
