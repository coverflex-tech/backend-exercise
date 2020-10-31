defmodule CompanyBenefitsWeb.ProductController do
  use CompanyBenefitsWeb, :controller

  alias CompanyBenefits.Products.ProductContext
  alias CompanyBenefits.Products.Product

  action_fallback(CompanyBenefitsWeb.FallbackController)

  def index(conn, _params) do
    products = ProductContext.list_products()
    render(conn, "index.json", products: products)
  end
end
