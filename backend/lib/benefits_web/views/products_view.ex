defmodule BenefitsWeb.ProductsView do
  use BenefitsWeb, :view

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      price: product.price
    }
  end

  def render("products.json", %{products: products}) do
    %{products: render_many(products, __MODULE__, "product.json", as: :product)}
  end
end
