defmodule CoverflexWeb.OrderView do
  use CoverflexWeb, :view
  alias CoverflexWeb.OrderView
  alias CoverflexWeb.ProductView

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, OrderView, "order.json")}
  end

  def render("show.json", %{order: order, products: products}) do
    %{
      "order" => %{
        "order_id" => order.id,
        "data" => %{
          "items" => render_many(products, ProductView, "product.json"),
          "total" => order.total
        }
      }
    }
  end

  def render("order.json", %{order: order}) do
    %{"order" => %{"id" => order.id, "total" => order.total}}
  end

  def render("404.json", %{not_found: model}) do
    case model do
      :user -> %{"error" => :user_not_found}
      :products -> %{"error" => :products_not_found}
    end
  end

  def render("400.json", %{error: reason}) do
    %{"error" => reason}
  end
end
