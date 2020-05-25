defmodule CoverFlexWeb.UserView do
  use CoverFlexWeb, :view

  def render("show.json", %{user: user, products: products}) do
    %{user: render_one(user, CoverFlexWeb.UserView, "user.json", products: products)}
  end

  def render("user.json", %{user: user, products: products}) do
    %{user_id: user.id,
      data: %{
        balance: user.balance,
        product_ids: products
      }
    }
  end
end
