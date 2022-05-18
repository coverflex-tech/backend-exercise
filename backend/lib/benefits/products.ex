defmodule Benefits.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Benefits.Repo

  alias Benefits.Products.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

 def sum_product_price(product_ids) when is_list(product_ids) do
    query =
      from p in Product,
        where: p.id in ^product_ids,
        select: sum(p.price)

    case Repo.one(query) do
      nil -> Decimal.new("0")
      result -> result
    end
  end

  def exists?(product_ids) when is_list(product_ids) do
    Product
    |> where([p], p.id in ^product_ids)
    |> Repo.aggregate(:count)
    |> then(fn count -> count == length(product_ids) end)
  end
end
