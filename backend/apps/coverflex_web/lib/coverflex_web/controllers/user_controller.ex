defmodule CoverflexWeb.UserController do
  use CoverflexWeb, :controller
  import Ecto.Query, only: [from: 2]

  alias Coverflex.Accounts
  alias Coverflex.Accounts.User
  alias Coverflex.Repo
  alias Coverflex.Orders.OrderItem

  action_fallback(CoverflexWeb.FallbackController)
  @new_user_balance 500

  def show(conn, %{"user_id" => user_id}) do
    case Accounts.get_user_by(:user_id, user_id) do
      nil ->
        {:ok, user} =
          Accounts.create_user_with_account(%{user_id: user_id, balance: @new_user_balance})

        conn
        |> put_status(201)
        |> render("show.json", user: user)

      %User{} = user ->
        user =
          user
          |> Repo.preload(:account)
          |> Repo.preload(orders: [order_items: from(oi in OrderItem, select: oi.product_id)])

        render(conn, "show.json", %{user: user})
    end
  end
end
