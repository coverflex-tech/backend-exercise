defmodule BenefitsWeb.OrdersController do
  use BenefitsWeb, :controller

  alias Benefits.Orders.Commands
  alias BenefitsWeb.Params.CreateOrderParams

  def create(conn, params) do
    params = Map.get(params, "order", %{})

    with {:ok, valid_params} <- CreateOrderParams.changeset(params),
         {:ok, order} <- Commands.create_order(valid_params) do
      conn
      |> put_status(200)
      |> render("order.json", order: order)
    else
      {:error, reason} ->
        conn
        |> put_status(400)
        |> put_view(ErrorView)
        |> render("400.json", reason: reason)
    end
  end
end
