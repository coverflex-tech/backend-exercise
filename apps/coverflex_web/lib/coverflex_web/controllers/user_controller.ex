defmodule CoverflexWeb.UserController do
  use CoverflexWeb, :controller

  alias Coverflex.Accounts
  alias Coverflex.Accounts.User

  action_fallback CoverflexWeb.FallbackController

  def show(conn, %{"user_id" => user_id}) do
    case Accounts.get_user_by(:user_id, user_id) do
      nil ->
        {:ok, user} = Accounts.create_user(%{user_id: user_id})

        conn
        |> put_status(201)
        |> render("show.json", user: user)

      %User{} = user ->
        render(conn, "show.json", user: user)
    end
  end
end
