defmodule BackendWeb.ProductController do
  use BackendWeb, :controller

  alias Backend.Benefits

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    products = Benefits.list_products()
    render(conn, "index.json", products: products)
  end
end
