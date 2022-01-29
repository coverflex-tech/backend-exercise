defmodule BenefitsWeb.OrderController do
  use BenefitsWeb, :controller

  alias Benefits.Orders

  action_fallback BenefitsWeb.FallbackController

  def create(conn, %{"order" => %{"items" => products_identifiers, "user_id" => username}}) do
    case Orders.create(username, products_identifiers) do
      {:ok, order} -> render(conn, "order.json", order: order)
      error -> error
    end
  end
end
