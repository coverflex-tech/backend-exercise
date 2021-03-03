defmodule Backend.Products.Manager do
  alias Backend.Products.Product
  alias Backend.Repo
  import Ecto.Query

  @moduledoc """
  Product manager module to handle product get operations:
   - GET
   - GET_BY
  """

  @callback get() :: {:ok, product :: list(Product.t())} | {:error, reason :: term()}
  @callback get(product_id :: binary()) :: {:ok, Product.t()} | {:error, reason :: term()}
  @callback get(product_ids :: list(binary())) ::
              {:ok, list(Product.t())} | {:error, reason :: term()}

  def get do
    Repo.all(Product)
  end

  def get(product_id) when is_binary(product_id) do
    case Repo.get(Product, product_id) do
      nil -> {:error, :invalid_product_id}
      product -> {:ok, product}
    end
  end

  def get(product_ids) do
    query =
      from(p in Product,
        where: p.id in ^product_ids
      )

    Repo.all(query)
  end
end
