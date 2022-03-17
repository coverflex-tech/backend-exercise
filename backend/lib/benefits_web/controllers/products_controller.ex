defmodule BenefitsWeb.ProductsController do
  use BenefitsWeb, :controller

  alias Benefits.Products.Queries

  def index(conn, _params) do
    products = Queries.all_products()

    conn
    |> put_status(200)
    |> render("products.json", products: products)
  end
end
