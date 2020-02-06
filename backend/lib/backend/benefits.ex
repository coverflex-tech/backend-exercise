defmodule Backend.Benefits do
  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Accounts
  alias Backend.Benefits.Product
  alias Backend.Benefits.Order

  def list_products do
    Repo.all(Product)
  end

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def create_order(attrs \\ %{}) do
    query =
      from p in Product,
        where: p.id in ^attrs["items"]

    list = Repo.all(query)
    user = Accounts.get_user(attrs["user_id"])
    {:ok, balance} = Map.fetch(user.data, "balance")

    order_attrs = %{
      data: %{
        items: order_items(list, attrs["items"]),
        total: order_total(list)
      },
      user: user
    }

    user_attrs = %{
      data: %{
        product_ids: order_attrs.data.items,
        balance: balance - order_attrs.data.total
      }
    }

    result =
      %Order{}
      |> Order.changeset(order_attrs)
      |> Repo.insert()

    case result do
      {:ok, order} ->
        Accounts.update_user(user, user_attrs)
        {:ok, order}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp order_total(list), do: Enum.reduce(list, 0, fn p, acc -> p.price + acc end)

  defp order_items(list, attr_list) do
    db_list = Enum.map(list, fn p -> p.id end)
    if Enum.all?(attr_list, fn item -> item in db_list end), do: attr_list, else: []
  end
end
