defmodule CoverflexWeb.OrderController do
  use CoverflexWeb, :controller

  alias Coverflex.Orders

  action_fallback(CoverflexWeb.FallbackController)

  #  def index(conn, _params) do
  #    orders = Orders.list_orders()
  #    render(conn, "index.json", orders: orders)
  #  end
  def create(conn, %{"order" => %{"user_id" => user_id, "items" => products}}) do
    # TODO: Usar fallback para os errors: https://hexdocs.pm/phoenix/Phoenix.Controller.html#action_fallback/1
    case Orders.buy_products(user_id, products) do
      {:ok, %{order: order, products: products}} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{order: order, products: products})

      {:error, :user, {:not_found, _}, _changes} ->
        conn
        |> put_status(:not_found)
        |> render("404.json", [{:not_found, :user}])

      {:error, :products, {:not_found, _}, _changes} ->
        conn
        |> put_status(:not_found)
        |> render("404.json", [{:not_found, :products}])

      {:error, :products_already_purchased, _products, _changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("400.json", [{:error, :products_already_purchased}])

      {:error, :sufficient_balance?, false, _changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("400.json", [{:error, :insufficient_balance}])
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
