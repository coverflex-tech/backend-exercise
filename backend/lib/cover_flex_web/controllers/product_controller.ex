defmodule CoverFlexWeb.ProductController do
  use CoverFlexWeb, :controller
  alias CoverFlex.Products

  def index(conn, _params) do
    products = Products.list_products()

    conn
    |> render("index.json", %{products: products})
  end
end
