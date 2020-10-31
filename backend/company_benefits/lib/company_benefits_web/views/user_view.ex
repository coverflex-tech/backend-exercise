defmodule CompanyBenefitsWeb.UserView do
  use CompanyBenefitsWeb, :view
  alias CompanyBenefitsWeb.UserView
  alias CompanyBenefits.Accounts

  def render("user.json", %{user: user}) do
    %{
      user: %{
        user_id: user.username,
        data: %{
          balance: user.balance,
          product_ids:
            Accounts.get_ordered_products(user) |> Enum.map(fn product -> product.identifier end)
        }
      }
    }
  end
end
