defmodule BackendWeb.FallbackController do
  use BackendWeb, :controller

  alias BackendWeb.ErrorView

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:error)
    |> put_view(ErrorView)
    |> render("error.json", error: reason)
  end
end
