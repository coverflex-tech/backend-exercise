defmodule BenefitsWeb.FallbackController do
  use BenefitsWeb, :controller

  def call(conn, %Ecto.Changeset{valid?: false} = changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BenefitsWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BenefitsWeb.ErrorView)
    |> render(:"404")
  end
end
