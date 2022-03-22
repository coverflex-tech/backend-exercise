defmodule BackendWeb.ProductController do
  use BackendWeb, :controller

  action_fallback BackendWeb.FallbackController

  alias Backend.Products

  def get(conn, _) do
    with product_list <- Products.List.call() do
      conn
      |> put_status(:ok)
      |> render("show_all.json", products: product_list)
    end
  end
end
