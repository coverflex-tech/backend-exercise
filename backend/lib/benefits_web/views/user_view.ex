defmodule BenefitsWeb.UserView do
  use BenefitsWeb, :view
  alias BenefitsWeb.UserView

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) when is_list(user.orders) do
    %{
      id: user.id,
      username: user.username,
      balance: user.balance,
      product_ids: build_product_ids(user.orders)
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      balance: user.balance
    }
  end

  def render("not_found.json", _) do
    %{error: "user_not_found"}
  end

  defp build_product_ids(orders) do
    orders
    |> Enum.reduce([], fn order, acc -> 
      order = Benefits.Repo.preload(order, [:items])
      items = Enum.map(order.items, & &1.id)

      Enum.concat(items, acc)
    end)
  end
end
