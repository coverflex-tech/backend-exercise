defmodule CoverFlexWeb.UserView do
  use CoverFlexWeb, :view

  def render("show.json", %{user: user}) do
    %{user: render_one(user, CoverFlexWeb.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{user_id: user.id,
      data: %{
        balance: user.balance,
        product_ids: []
      }
    }
  end
end
