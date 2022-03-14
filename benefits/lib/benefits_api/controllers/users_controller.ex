defmodule BenefitsAPI.UsersController do
  @moduledoc false

  use BenefitsAPI, :controller

  alias BenefitsAPI.UsersView

  def show(conn, %{"user_id" => username}) do
    {:ok, user} = Benefits.get_or_create_user(username)

    conn
    |> put_status(:ok)
    |> put_view(UsersView)
    |> render("user.json", %{user: user})
  end
end
