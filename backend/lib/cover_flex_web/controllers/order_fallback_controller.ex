defmodule CoverFlexWeb.OrderFallbackController do
  use CoverFlexWeb, :controller
  import Plug.Conn
  alias CoverFlexWeb.OrderView

  def call(conn, {:error, changeset}) do
    case List.first(changeset.errors) do
      {:products, {"is invalid", _}} ->
        conn
        |> put_status(:bad_request)
        |> put_view(OrderView)
        |> render("products_not_found.json")

      {:products, {"products already purchased", _}} ->
        conn
        |> put_status(:bad_request)
        |> put_view(OrderView)
        |> render("already_bought.json")

      {:total, {"insufficient balance", _}} ->
        conn
        |> put_status(:bad_request)
        |> put_view(OrderView)
        |> render("poor.json")
    end
  end
end
