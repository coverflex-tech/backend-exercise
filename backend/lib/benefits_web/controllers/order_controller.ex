defmodule BenefitsWeb.OrderController do
  use BenefitsWeb, :controller

  alias Benefits.{Orders, Repo}
  alias Benefits.Orders.Inputs.CreateOrderInput

  action_fallback BenefitsWeb.FallbackController

  def index(conn, _params) do
    orders =
      Orders.list_orders()
      |> Repo.preload([:user, :items])
    render(conn, "index.json", orders: orders)
  end

  def create(conn, params) do
    with %{valid?: true, changes: input} <- CreateOrderInput.changeset(params),
         {:ok, order} <- Orders.create_order(input.username, input.items) do
      conn
      |> put_status(:created)
      |> render("show.json", order: order)
    end
  end
end
