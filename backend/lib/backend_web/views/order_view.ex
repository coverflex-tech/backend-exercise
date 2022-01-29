defmodule BenefitsWeb.OrderView do
  use BenefitsWeb, :view

  alias BenefitsWeb.ProductView

  def render("order.json", %{order: order}) do
    %{
      order: %{
        order_id: order.id,
        data: %{
          items: render_many(order.products, ProductView, "product.json"),
          total: order.total
        }
      }
    }
  end
end
