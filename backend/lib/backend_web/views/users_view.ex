defmodule BackendWeb.UsersView do
  use BackendWeb, :view

  alias Backend.Users.User

  def render("user.json", %{
        user: %User{username: username, balance: balance, orders: orders}
      }) do
    %{
      user: %{
        user_id: username,
        data: %{balance: Decimal.to_float(balance), product_ids: get_products_ids(orders)}
      }
    }
  end

  defp get_products_ids([]) do
    []
  end

  defp get_products_ids(orders) do
    IO.puts("asdasdas")

    orders
    |> Enum.map(fn %{products: products} -> products end)
    |> List.first()
    |> Enum.map(fn %{id: id} -> id end)
  end
end
