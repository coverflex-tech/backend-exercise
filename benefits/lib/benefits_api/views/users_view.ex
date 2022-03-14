defmodule BenefitsAPI.UsersView do
  @moduledoc false

  use BenefitsAPI, :view

  def render("user.json", %{user: user, bought_products_ids: bought_products_ids}) do
    %{
      user: %{
        user_id: user.username,
        data: %{
          balance: render_money(user.wallet.amount),
          product_ids: bought_products_ids
        }
      }
    }
  end
end
