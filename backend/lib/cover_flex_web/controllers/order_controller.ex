defmodule CoverFlexWeb.OrderController do
  use CoverFlexWeb, :controller
  alias CoverFlex.Accounts
  alias CoverFlex.Products

  action_fallback CoverFlexWeb.OrderFallbackController

  def create(conn, %{"order" => %{"items" => product_ids, "user_id" => user_id}}) do
    attrs = %{user_id: user_id, product_ids: product_ids}

    with {:ok, order} <- Products.create_order(attrs) do
      Accounts.bill_user(order.user, order.total)

      conn
      |> render("show.json", %{order: order})
    end
  end
end
