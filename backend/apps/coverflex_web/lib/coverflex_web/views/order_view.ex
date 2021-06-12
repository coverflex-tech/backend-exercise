defmodule CoverflexWeb.OrderView do
  use CoverflexWeb, :view
  alias CoverflexWeb.OrderView

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{order: %{id: order.id, total: order.total}}
  end
end
