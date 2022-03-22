defmodule BackendWeb.OrderItemView do
  use BackendWeb, :view

  def render("item_product_id.json", %{order_item: item}) do
    item.product_id
  end
end
