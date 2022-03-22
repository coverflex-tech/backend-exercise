defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Benefits
  action_fallback BackendWeb.FallbackController

  def get_or_create_user(conn, %{"username" => username}) do
    {:ok, user} = Benefits.get_or_create_user(%{username: username})
    render(conn, "show.json", user: user)
  end
end
