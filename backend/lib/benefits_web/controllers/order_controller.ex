defmodule BenefitsWeb.OrderController do
  use BenefitsWeb, :controller

  alias Benefits.Orders
  alias Benefits.Orders.Inputs.CreateOrderInput

  action_fallback BenefitsWeb.FallbackController

  def create(conn, params) do
    with %{valid?: true, changes: input} <- CreateOrderInput.changeset(params),
         {:ok, order} <- Orders.create_order(input.username, input.items) do
      conn
      |> put_status(:created)
      |> render("show.json", order: order, username: input.username)
    end
  end
end
