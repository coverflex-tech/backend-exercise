defmodule BenefitsWeb.UsersController do
  use BenefitsWeb, :controller

  alias Benefits.Orders
  alias Benefits.Users

  def show(conn, %{"user_id" => user_id}) do
    with {:ok, user} <-
           Users.Queries.get_user_by_username(user_id),
         purchases <-
           Orders.Queries.get_user_purchases(user) do
      return_user(conn, user, purchases)
    else
      {:error, :user_not_found} ->
        fallback_to_user_creation(conn, user_id)
    end
  end

  defp fallback_to_user_creation(conn, user_id) do
    user = Users.Commands.create_user!(user_id)
    return_user(conn, user, [])
  end

  defp return_user(conn, user, purchases) do
    conn
    |> put_status(200)
    |> render("user.json", user: user, purchases: purchases)
  end
end
