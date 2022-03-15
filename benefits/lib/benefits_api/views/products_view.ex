defmodule BenefitsAPI.ProductsView do
  @moduledoc false

  use BenefitsAPI, :view

  def render("index.json", %{products: products}) do
    %{products: render_many(products, __MODULE__, "product.json", as: :product)}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id, name: product.name, price: render_money(product.price)}
  end
end
