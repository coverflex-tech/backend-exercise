defmodule CompanyBenefitsWeb.ProductView do
  use CompanyBenefitsWeb, :view
  alias CompanyBenefitsWeb.ProductView

  def render("index.json", %{products: products}) do
    %{products: render_many(products, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.identifier, name: product.name, price: product.price}
  end
end
