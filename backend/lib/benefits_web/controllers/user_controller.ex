defmodule BenefitsWeb.UserController do
  use BenefitsWeb, :controller

  alias Benefits.Accounts
  alias Benefits.Accounts.User

  action_fallback BenefitsWeb.FallbackController

  def show(conn, %{"user_id" => user_id}) do
    case Accounts.get_user(user_id) do
      %User{} = user ->
        render(conn, "show.json", user: user)

      nil ->
        {:error, :not_found}
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user.user_id))
      |> render("show.json", user: user)
    end
  end
end
