defmodule BenefitsWeb.OrderView do
  use BenefitsWeb, :view
  alias BenefitsWeb.OrderView

  def render("show.json", %{order: order}) do
    %{order: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{
      order_id: order.id,
      data: %{
        items: order.items,
        total: Decimal.to_float(order.total)
      }
    }
  end
end
