defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Benefits

  action_fallback BackendWeb.FallbackController

  def show(conn, %{"user_id" => user_id}) do
    user =
      case Benefits.get_user(user_id) do
        nil ->
          {:ok, new_user} = Benefits.create_user(%{user_id: user_id})
          new_user

        existing_user ->
          existing_user
      end
      |> Backend.Repo.preload(:products)

    render(conn, "show.json", user: user)
  end
end
