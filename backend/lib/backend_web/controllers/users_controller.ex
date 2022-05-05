defmodule BackendWeb.UsersController do
  use BackendWeb, :controller

  alias Backend.FallbackController
  alias Backend.Users.Services.GetUser
  alias Backend.Users.User

  action_fallback FallbackController

  def get(conn, params) do
    {:ok, %User{} = user} = GetUser.call(params)

    conn
    |> put_status(:ok)
    |> render("user.json", user: user)
  end
end
