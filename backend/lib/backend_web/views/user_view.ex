defmodule BackendWeb.UserView do
  use BackendWeb, :view

  def render("show.json", %{user: user}) do
    %{
      user: %{
        user_id: user.user_id,
        data: %{
          balance: user.balance,
          product_ids: user.products |> Enum.map(fn product -> product.id end)
        }
      }
    }
  end
end
