defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Benefits
  alias Backend.Benefits.User

  action_fallback BackendWeb.FallbackController

  def show(conn, %{"user_id" => user_id}) do
    # user = Benefits.get_user!(user_id)
    user = %User{user_id: user_id, balance: 42}
    render(conn, "show.json", user: user)
  end
end
