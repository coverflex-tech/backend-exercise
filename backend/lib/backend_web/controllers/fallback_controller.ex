defmodule BackendWeb.FallbackController do
  use BackendWeb, :controller

  def call(conn, {:error, result}) when is_atom(result) do
    conn
    |> put_status(:bad_request)
    |> put_view(BackendWeb.ErrorView)
    |> render("400.json", error: Atom.to_string(result))
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BackendWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
