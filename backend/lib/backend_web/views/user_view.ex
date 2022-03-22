defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView
  alias BackendWeb.OrderItemView

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      user_id: user.id,
      data: %{
        balance: user.balance,
        product_ids: render_many(user.order_items, OrderItemView, "item_product_id.json")
      }
    }
  end
end
