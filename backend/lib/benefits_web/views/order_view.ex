defmodule BenefitsWeb.OrderView do
  use BenefitsWeb, :view
  alias BenefitsWeb.{OrderView, UserView, ProductView}

  def render("index.json", %{orders: orders}) do
    %{orders: render_many(orders, OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{order: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{
      id: order.id,
      user: render_one(order.user, UserView, "user.json"),
      items: render_many(order.items, ProductView, "product.json"),
    }
  end

  def render("products_not_found.json", _) do
    %{error: "products_not_found"}
  end

  def render("products_already_purchased.json", _) do
    %{error: "products_already_purchased"}
  end

  def render("insufficient_balance.json", _) do
    %{error: "insufficient_balance"}
  end
end
