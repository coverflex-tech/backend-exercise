defmodule CoverflexWeb.ProductController do
  use CoverflexWeb, :controller

  alias Coverflex.Products

  action_fallback(CoverflexWeb.FallbackController)

  def index(conn, _params) do
    products = Products.list_products()
    render(conn, "index.json", products: products)
  end
end
