defmodule Benefits.Products.Queries do
  @moduledoc """
  Queries the product schema.
  """

  alias Benefits.Products.Product
  alias Benefits.Repo

  import Ecto.Query

  @spec all_products :: [Product.t()]
  def all_products, do: Repo.all(Product)

  @spec get_products([String.t()]) :: {:error, :products_not_found} | {:ok, [Product.t()]}
  def get_products(ids) when is_list(ids) do
    Product
    |> where([p], p.id in ^ids)
    |> Repo.all()
    |> case do
      [] -> {:error, :products_not_found}
      products -> {:ok, products}
    end
  end
end
