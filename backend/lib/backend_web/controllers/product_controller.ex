defmodule BackendWeb.ProductController do
  use BackendWeb, :controller

  alias Backend.Benefits
  alias Backend.Benefits.Product

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    products = Benefits.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- Benefits.create_product(product_params) do
      conn
      |> put_status(:created)
      |> render("show.json", product: product)
    end
  end
end
