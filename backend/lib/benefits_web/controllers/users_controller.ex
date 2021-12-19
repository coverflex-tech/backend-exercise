defmodule BenefitsWeb.UserController do
  use BenefitsWeb, :controller

  alias Benefits.Users
  alias Benefits.Users.User

  action_fallback BenefitsWeb.FallbackController

  def show_or_create(conn, %{"username" => username}) do
    case Users.get_user(username) do
      nil ->
        input = %{username: username, balance: 500}

        with {:ok, %User{} = user} <- Users.create_user(input) do
          conn
          |> put_status(:created)
          |> render("show.json", user: user)
        end

      user ->
        render(conn, "show.json", user: user)
    end
  end
end
