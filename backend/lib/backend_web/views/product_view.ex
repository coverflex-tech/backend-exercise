defmodule BackendWeb.ProductView do
  use BackendWeb, :view
  alias BackendWeb.{AmountHelpers, ProductView}

  def render("index.json", %{products: products}) do
    %{products: render_many(products, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      price: AmountHelpers.centify(product.price)
    }
  end
end
