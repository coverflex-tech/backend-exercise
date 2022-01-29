defmodule BenefitsWeb.ProductController do
  use BenefitsWeb, :controller

  alias Benefits.Products

  action_fallback BenefitsWeb.FallbackController

  def index(conn, _params) do
    case Products.list() do
      {:ok, products} -> render(conn, "index.json", products: products)
      error -> error
    end
  end
end
