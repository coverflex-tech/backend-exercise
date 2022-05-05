defmodule BackendWeb.ProductsController do
  use BackendWeb, :controller

  alias Backend.Products.Services.List

  def list(conn, _) do
    {:ok, products} = List.call()

    conn
    |> put_status(:ok)
    |> render("products.json", products: products)
  end
end
