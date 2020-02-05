defmodule Backend.Benefits do
  import Ecto.Query, warn: false
  alias Backend.Repo

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

    parsed_attrs = %{
      data: %{
        items: order_items(list, attrs["items"]),
        total: order_total(list)
      },
      user_id: attrs["user_id"]
    }

    %Order{}
    |> Order.changeset(parsed_attrs)
    |> Repo.insert()
  end

  defp order_total(list) do
    if Enum.all?(list) do
      Enum.reduce(list, 0, fn p, acc -> p.price + acc end)
    else
      nil
    end
  end

  defp order_items(list, attr_list) do
    db_list = Enum.map(list, fn p -> p.id end)
    if db_list == attr_list, do: db_list, else: []
  end
end
