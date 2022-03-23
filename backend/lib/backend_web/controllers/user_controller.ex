defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Benefits
  action_fallback(BackendWeb.FallbackController)

  def get_or_create_user(conn, %{"username" => username}) do
    with {:ok, user} <- Benefits.get_or_create_user(%{username: username}),
         products <- Benefits.list_products_bought_by_user(user) do
      render(conn, "user.json", user: user, products: products)
    end
  end
end
