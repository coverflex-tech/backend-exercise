defmodule CompanyBenefitsWeb.OrderView do
  use CompanyBenefitsWeb, :view
  alias CompanyBenefitsWeb.OrderView
  alias CompanyBenefits.Orders

  def render("show.json", %{order: order}) do
    %{order: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{
      order_id: order.id,
      data: %{
        total: order.total,
        items: render_many(order.products, OrderView, "order_product.json")
      }
    }
  end

  def render("order_product.json", %{order: product}) do
    product.identifier
  end
end
