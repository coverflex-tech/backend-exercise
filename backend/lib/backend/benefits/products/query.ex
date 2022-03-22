defmodule Backend.Benefits.Products.Query do
  import Ecto.Query, warn: false

  alias Backend.Benefits.Products.Product

  def products_bought_by_user_query(_user = %{id: user_id}) do
    Product
    |> join(:inner, [p], op in "ordered_products", on: op.product_id == p.id)
    |> join(:inner, [_p, op], o in "orders", on: op.order_id == o.id)
    |> where([_p, _op, o], o.user_id == ^user_id)
    |> select([p, _op, _o], p)
  end

  def filter_by_product_string_ids_list(query, product_string_ids) do
    query
    |> where([p], p.string_id in ^product_string_ids)
  end
end
