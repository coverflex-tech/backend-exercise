defmodule BackendWeb.OrderView do
  use BackendWeb, :view
  alias BackendWeb.OrderView

  def render("show.json", %{order: order}) do
    %{order: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{order_id: order.id, data: order.data}
  end
end
