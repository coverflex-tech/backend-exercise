defmodule CoverflexWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CoverflexWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CoverflexWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CoverflexWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :user, {:not_found, _}, _changes}) do
    conn
    |> put_status(:not_found)
    |> render("404.json", [{:not_found, :user}])
  end

  def call(conn, {:error, :products, {:not_found, _}, _changes}) do
    conn
    |> put_status(:not_found)
    |> render("404.json", [{:not_found, :products}])
  end

  def call(conn, {:error, :products_already_purchased, _products, _changeset}) do
    conn
    |> put_status(:bad_request)
    |> render("400.json", [{:error, :products_already_purchased}])
  end

  def call(conn, {:error, :sufficient_balance?, false, _changeset}) do
    conn
    |> put_status(:bad_request)
    |> render("400.json", [{:error, :insufficient_balance}])
  end
end
