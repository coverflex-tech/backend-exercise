defmodule BenefitsWeb.UserView do
  use BenefitsWeb, :view
  alias BenefitsWeb.UserView

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      user: %{
        user_id: user.user_id,
        data: %{
          balance: user.balance,
          products: Enum.map(user.products, & &1.identifier)
        }
      }
    }
  end
end
