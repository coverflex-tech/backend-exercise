defmodule BenefitsWeb.ProductView do
  use BenefitsWeb, :view
  alias BenefitsWeb.ProductView

  def render("index.json", %{products: products}) do
    %{products: render_many(products, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.identifier, name: product.name, price: product.price}
  end
end
