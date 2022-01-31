defmodule BenefitsWeb.ProductController do
  use BenefitsWeb, :controller

  alias Benefits.Perks

  def index(conn, _params) do
    products = Perks.list_products()
    render(conn, "index.json", products: products)
  end
end
