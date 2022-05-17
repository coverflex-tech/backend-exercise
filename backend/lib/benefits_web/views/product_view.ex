defmodule BenefitsWeb.ProductView do
  use BenefitsWeb, :view
  alias BenefitsWeb.ProductView

  def render("index.json", %{products: products}) do
    %{products: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      price: Decimal.to_float(product.price)
    }
  end
end
