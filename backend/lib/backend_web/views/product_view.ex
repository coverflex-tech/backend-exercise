defmodule BackendWeb.ProductView do
  use BackendWeb, :view
  alias BackendWeb.ProductView

  def render("index.json", %{products: products}) do
    %{products: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{product: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      price: product.price / 100
    }
  end
end
