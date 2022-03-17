defmodule BenefitsWeb.UsersController do
  alias Benefits.Users.Commands
  alias Benefits.Users.Queries

  alias BenefitsWeb.Params.GetUserParams
  alias BenefitsWeb.ErrorView

  use BenefitsWeb, :controller

  def show(conn, params) do
    with {:ok, valid_params} <- GetUserParams.changeset(params),
         {:ok, user} <-
           Queries.get_user(valid_params) do
      return_user(conn, user)
    else
      {:error, :invalid_params} ->
        conn |> put_status(400) |> put_view(ErrorView) |> render("400.json")

      {:not_found, user_id} ->
        fallback_to_user_creation(conn, user_id)
    end
  end

  defp fallback_to_user_creation(conn, user_id) do
    {:ok, user} = Commands.create_user(%{username: user_id})
    return_user(conn, user)
  end

  defp return_user(conn, user) do
    conn
    |> put_status(200)
    |> render("user.json", user: user)
  end
end
