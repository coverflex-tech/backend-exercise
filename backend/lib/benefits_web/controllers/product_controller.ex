defmodule BenefitsWeb.ProductController do
  use BenefitsWeb, :controller

  alias Benefits.Products

  action_fallback BenefitsWeb.FallbackController

  def index(conn, _params) do
    products = Products.list_products()
    render(conn, "index.json", products: products)
  end
end
