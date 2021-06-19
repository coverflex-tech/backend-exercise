defmodule CoverflexWeb.OrderController do
  use CoverflexWeb, :controller

  alias Coverflex.Orders

  action_fallback(CoverflexWeb.FallbackController)

  def create(conn, %{"order" => %{"user_id" => user_id, "items" => products}}) do
    with {:ok, %{order: order, products: products}} <- Orders.buy_products(user_id, products) do
      conn
      |> put_status(:created)
      |> render("show.json", %{order: order, products: products})
    end
  end
end
