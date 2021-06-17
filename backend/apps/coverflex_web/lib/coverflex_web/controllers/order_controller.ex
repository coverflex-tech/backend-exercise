defmodule CoverflexWeb.OrderController do
  use CoverflexWeb, :controller

  alias Coverflex.Orders
  alias Coverflex.Orders.Order

  action_fallback(CoverflexWeb.FallbackController)

  #  def index(conn, _params) do
  #    orders = Orders.list_orders()
  #    render(conn, "index.json", orders: orders)
  #  end

  def create(conn, %{"order" => %{"user_id" => user_id, "items" => products}}) do
    case Orders.buy_products(user_id, products) do
      {:ok, %{order: order}} ->
        conn
        |> put_status(:created)
        |> render("show.json", order: order)
    end
  end

  #  def show(conn, %{"id" => id}) do
  #    order = Orders.get_order!(id)
  #    render(conn, "show.json", order: order)
  #  end

  #  def update(conn, %{"id" => id, "order" => order_params}) do
  #    order = Orders.get_order!(id)
  #
  #    with {:ok, %Order{} = order} <- Orders.update_order(order, order_params) do
  #      render(conn, "show.json", order: order)
  #    end
  #  end
  #
  #  def delete(conn, %{"id" => id}) do
  #    order = Orders.get_order!(id)
  #
  #    with {:ok, %Order{}} <- Orders.delete_order(order) do
  #      send_resp(conn, :no_content, "")
  #    end
  #  end
end
