defmodule BackendWeb.UsersController do
  use BackendWeb, :controller

  alias Backend.Users.Services.GetUser
  alias Backend.Users.User

  def get(conn, params) do
    {:ok, %User{} = user} = GetUser.call(params)

    conn
    |> put_status(:ok)
    |> render("user.json", user: user)
  end
end
