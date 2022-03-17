defmodule BenefitsWeb.OrdersView do
  use BenefitsWeb, :view

  def render("order.json", %{order: order}) do
    %{
      order: %{
        order_id: order.id,
        data: %{
          items:
            render_many(
              order.products,
              BenefitsWeb.ProductsView,
              "product.json",
              as: :product
            ),
          total: order.total_price
        }
      }
    }
  end
end
