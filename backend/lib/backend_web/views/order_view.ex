defmodule BackendWeb.OrderView do
  use BackendWeb, :view
  alias BackendWeb.OrderView

  def render("show.json", %{order: order}) do
    %{order: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{
      id: order.id,
      data: %{items: [], total: order.total_value}
    }
  end
end
