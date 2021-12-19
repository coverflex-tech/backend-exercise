defmodule BenefitsWeb.ProductController do
  use BenefitsWeb, :controller

  alias Benefits.Products
  alias Benefits.Products.Inputs.CreateProductInput

  action_fallback BenefitsWeb.FallbackController

  def index(conn, _params) do
    products = Products.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, params) do
    with %{valid?: true, changes: input} <- CreateProductInput.changeset(params),
         {:ok, product} <- Products.create_product(input) do
      conn
      |> put_status(:created)
      |> render("show.json", product: product)
    end
  end
end
