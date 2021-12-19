defmodule BenefitsWeb.UserView do
  use BenefitsWeb, :view
  alias BenefitsWeb.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      balance: user.balance
    }
  end
end
