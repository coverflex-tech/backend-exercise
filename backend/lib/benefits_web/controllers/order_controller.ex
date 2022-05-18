defmodule BenefitsWeb.OrderController do
  use BenefitsWeb, :controller

  alias Benefits.Orders
  alias Benefits.Users
  alias Benefits.Orders.Order

  action_fallback BenefitsWeb.FallbackController

  def create(conn, %{"order" => order_params}) do
    with user <- Users.get_user_by_username(order_params["user_id"]),
         order_params <- Map.put(order_params, "user_id", user.id),
         {:ok, %{order: order}} <- Orders.create_order(order_params) do
      conn
      |> put_status(:created)
      |> render("show.json", order: %{order | items: order_params["items"]})
    end
  end
end
