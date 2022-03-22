defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  action_fallback BackendWeb.FallbackController

  alias Backend.Users
  alias Backend.Users.Schemas.User

  def show(conn, %{"user_id" => id}) do
    with {:ok, %User{} = user} <- Users.get_or_create(%{id: id}) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end
end
