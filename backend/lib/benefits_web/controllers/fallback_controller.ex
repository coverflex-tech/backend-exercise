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
    |> put_status(404)
    |> put_view(BenefitsWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :user_not_found}) do
    conn
    |> put_status(422)
    |> put_view(BenefitsWeb.UserView)
    |> render("not_found.json")
  end

  def call(conn, {:error, :products_not_found}) do
    conn
    |> put_status(422)
    |> put_view(BenefitsWeb.OrderView)
    |> render("products_not_found.json")
  end

  def call(conn, {:error, :products_already_purchased}) do
    conn
    |> put_status(422)
    |> put_view(BenefitsWeb.OrderView)
    |> render("products_already_purchased.json")
  end

  def call(conn, {:error, :insufficient_balance}) do
    conn
    |> put_status(422)
    |> put_view(BenefitsWeb.OrderView)
    |> render("insufficient_balance.json")
  end
end
