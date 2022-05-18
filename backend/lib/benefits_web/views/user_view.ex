defmodule BenefitsWeb.UserView do
  use BenefitsWeb, :view
  alias BenefitsWeb.UserView

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      user_id: user.username,
      data: %{
        balance: user.balance,
        product_ids: user.products |> Enum.map(& &1.id)
      }
    }
  end
end
