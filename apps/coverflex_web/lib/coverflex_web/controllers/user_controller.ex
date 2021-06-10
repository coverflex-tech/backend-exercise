defmodule CoverflexWeb.UserController do
  use CoverflexWeb, :controller

  alias Coverflex.Accounts
  alias Coverflex.Accounts.User

  action_fallback CoverflexWeb.FallbackController

  def show(conn, %{"user_id" => user_id}) do
    user = Accounts.get_user_by(:user_id, user_id)
    render(conn, "show.json", user: user)
  end
end
