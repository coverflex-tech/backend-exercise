defmodule CoverflexWeb.UserView do
  use CoverflexWeb, :view
  alias CoverflexWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    user_data = %{
      user: %{
        id: user.id,
        user_id: user.user_id,
        data: %{balance: user.account.balance, product_ids: []}
      }
    }

    case user.orders do
      nil ->
        user_data

      %Ecto.Association.NotLoaded{} ->
        user_data

      orders ->
        products =
          Enum.reduce(orders, [], fn order, acc -> [order.order_items | acc] end)
          |> Enum.flat_map(fn order_item -> order_item end)

        put_in(user_data, [:user, :data, :product_ids], products)
    end
  end
end
