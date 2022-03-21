defmodule BackendWeb.ProductView do
  use BackendWeb, :view
  alias BackendWeb.ProductView

  def render("show_all.json", %{products: product}) do
    %{products: render_many(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      price: product.price
    }
  end
end
