defmodule BenefitsWeb.OrderView do
  use BenefitsWeb, :view
  alias BenefitsWeb.OrderView

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{
      id: order.id,
      user_id: order.user_id
    }
  end
end
