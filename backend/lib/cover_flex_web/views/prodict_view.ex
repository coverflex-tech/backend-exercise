defmodule CoverFlexWeb.ProductView do
  use CoverFlexWeb, :view

  def render("index.json", %{products: products}) do
    %{products: render_many(products, __MODULE__, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      price: product.price}
  end
end
