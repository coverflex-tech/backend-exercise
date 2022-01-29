defmodule BenefitsWeb.UserView do
  use BenefitsWeb, :view

  def render("user.json", %{user: user}) do
    %{
      user: %{
        user_id: user.username,
        data: %{
          balance: user.balance,
          product_ids: Enum.map(user.products, & &1.identifier)
        }
      }
    }
  end
end
