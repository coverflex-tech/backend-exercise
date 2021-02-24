defmodule BackendWeb.UsersController do
  use BackendWeb, :controller
  alias Backend.User

  def get_or_create(conn, %{"user_id" => user_id}) do
    {:ok, user} = User.get_or_create(user_id)
    json(conn, %{user: user})
  end
end
