defmodule BenefitsAPI.ProductsController do
  @moduledoc false

  use BenefitsAPI, :controller

  alias BenefitsAPI.ProductsView

  def index(conn, _params) do
    {:ok, products} = Benefits.list_products()

    conn
    |> put_status(:ok)
    |> put_view(ProductsView)
    |> render("index.json", %{products: products})
  end
end
