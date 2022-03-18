defmodule BenefitsWeb.UsersView do
  use BenefitsWeb, :view

  def render("user.json", %{user: user, purchases: purchases}) do
    %{
      user: %{
        user_id: user.username,
        data: %{
          balance: user.balance,
          product_ids: purchases
        }
      }
    }
  end
end
