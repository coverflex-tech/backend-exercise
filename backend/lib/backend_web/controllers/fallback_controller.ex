defmodule BenefitsWeb.FallbackController do
  use BenefitsWeb, :controller

  def call(conn, {:error, error}) when is_binary(error) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: error})
  end

  def call(conn, _), do: conn |> put_status(:internal_server_error)
end
