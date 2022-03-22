defmodule BackendWeb.OrderView do
  use BackendWeb, :view
  alias BackendWeb.OrderView
  alias BackendWeb.OrderItemView

  def render("show.json", %{order: order}) do
    %{order: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{
      id: order.id,
      user_id: order.user_id,
      total: order.total,
      items: render_many(order.order_items, OrderItemView, "item_product_id.json")
    }
  end
end
