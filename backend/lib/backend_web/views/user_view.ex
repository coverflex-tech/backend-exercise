defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      user_id: user.id,
      data: %{
        balance: user.balance,
        product_ids: render_many(user.order_items, UserView, "user_products.json")
      }
    }
  end

  def render("user_products.json", %{product: product}) do
    product.id
  end
end
