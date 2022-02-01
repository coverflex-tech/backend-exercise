defmodule BenefitsWeb.UserController do
  @moduledoc """
  Contains the controller functions that respond to specific endpoints related to user resources.
  """

  use BenefitsWeb, :controller

  alias Benefits.Accounts
  alias Benefits.Accounts.User

  action_fallback BenefitsWeb.FallbackController

  @spec show(Plug.Conn.t(), map) :: {:error, :not_found} | Plug.Conn.t()
  def show(conn, %{"user_id" => user_id}) do
    case Accounts.get_user(user_id) do
      %User{} = user ->
        render(conn, "show.json", user: user)

      nil ->
        {:error, :not_found}
    end
  end

  @spec create(Plug.Conn.t(), map) :: {:error, Ecto.Changeset.t()} | {:ok, any} | Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user.user_id))
      |> render("show.json", user: user)
    end
  end
end
