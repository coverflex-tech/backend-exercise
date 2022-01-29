defmodule Benefits.Products do
  @moduledoc """
  The `Products` context.
  It provides direct actions with `Product` schema and `products` table
  """
  alias Benefits.Product
  alias Benefits.Products.Query
  alias Benefits.Repo

  @doc """
  Lists all products with optional `products_identifiers`

  Returns `[%Product{}, ...]`

  ### Examples

    iex> Benefits.Products.list("product_a")
    {:error, "not_allowed"}

    iex> Benefits.Products.list("product_a")
    [%Product{id: "product_a"}]

    iex> Benefits.Products.get_by_id()
    [%Product{}, ...]

  """
  def list(products_identifiers \\ []) do
    {:ok,
     Product
     |> Query.filter_by_products_identifiers(products_identifiers)
     |> Repo.all()}
  end

  @doc """
  Sums all the prices from all the `products`

  Returns `{:ok, <float>}` or `{:ok, 0.0}` or `{:error, "not_allowed"}`

  ### Examples

    iex> Benefits.Products.sum_products_prices([])
    {:ok, 0.0}

    iex> Benefits.Products.sum_products_prices([%Product{price: 1.2}, %Product{price: 1.23}])
    {:ok, 2.43}

    iex> Benefits.Products.sum_products_prices("not_valid")
    {:error, "not_allowed"}

  """
  def sum_products_prices(products)
  def sum_products_prices([]), do: {:ok, 0.0}
  def sum_products_prices(products), do: {:ok, products |> Enum.map(& &1.price) |> Enum.sum()}
end
