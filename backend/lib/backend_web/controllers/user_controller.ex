defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Accounts

  action_fallback BackendWeb.FallbackController

  def show(conn, %{"user_id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.json", user: user)
  end
end
