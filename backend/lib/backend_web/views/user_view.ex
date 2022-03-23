defmodule BackendWeb.UserView do
  use BackendWeb, :view

  def render("user.json", %{user: user, products: products}) do
    product_ids = Enum.map(products, & &1.string_id)

    %{
      user: %{
        user_id: user.username,
        data: %{balance: user.balance, product_ids: product_ids}
      }
    }
  end
end
