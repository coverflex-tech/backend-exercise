defmodule BenefitsWeb.UsersController do
  alias Benefits.Users.Commands
  alias Benefits.Users.Queries

  alias BenefitsWeb.Params.GetUserParams
  alias BenefitsWeb.ErrorView

  use BenefitsWeb, :controller

  def show(conn, params) do
    with {:ok, %{user_id: user_id}} <- GetUserParams.changeset(params),
         {:ok, user} <-
           Queries.get_user_by_username(user_id) do
      return_user(conn, user)
    else
      {:error, :invalid_params} ->
        conn |> put_status(400) |> put_view(ErrorView) |> render("400.json")

      {:error, :user_not_found} ->
        fallback_to_user_creation(conn, params)
    end
  end

  defp fallback_to_user_creation(conn, %{"user_id" => user_id}) do
    user = Commands.create_user!(user_id)
    return_user(conn, user)
  end

  defp return_user(conn, user) do
    conn
    |> put_status(200)
    |> render("user.json", user: user)
  end
end
