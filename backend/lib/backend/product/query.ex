defmodule Benefits.Products.Query do
  @moduledoc """
  The `Products` context query functions.
  It provides query functions to help the context, without
  causing too much disruption for the developers who only
  want to undestand what each function does on the context
  side without worrying about query stuff.
  """
  import Ecto.Query, warn: false

  alias Benefits.Product

  def base, do: Product

  @doc """
  Filters the products by given `products_identifiers`.

  Returns `#Ecto.Query<>`

  ## Examples

    iex> Benefits.Products.Query.filter_by_products_identifiers(query, ["product_a", "product_b"])
    query

  """
  def filter_by_products_identifiers(query \\ base(), products_identifiers)
  def filter_by_products_identifiers(query, []), do: query

  def filter_by_products_identifiers(query, products_identifiers),
    do: query |> where([p], p.identifier in ^products_identifiers)
end
