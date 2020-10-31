defmodule CompanyBenefitsWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CompanyBenefitsWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(CompanyBenefitsWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:not_found, message}) do
    conn
    |> put_status(:not_found)
    |> render(CompanyBenefitsWeb.ErrorView, :"404", message: message)
  end

  def call(conn, _) do
    conn
    |> put_status(:bad_request)
    |> render(CompanyBenefitsWeb.ErrorView, :"400")
  end
end
