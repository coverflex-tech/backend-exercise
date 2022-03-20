defmodule BenefitsAPI.OrdersView do
  @moduledoc false

  use BenefitsAPI, :view

  def render("order.json", %{order: order}) do
    %{
      order: %{
        order_id: order.id,
        data: %{
          items: Enum.map(order.products, & &1.id),
          total: render_money(order.price)
        }
      }
    }
  end
end
