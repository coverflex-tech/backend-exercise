defmodule CoverflexWeb.UserController do
  use CoverflexWeb, :controller

  alias Coverflex.Accounts
  alias Coverflex.Accounts.User

  action_fallback CoverflexWeb.FallbackController

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end
end
