defmodule CoverFlex.Products do
  @moduledoc """
  Products is the context that deals with benefits and their ordering of.
  """
  alias CoverFlex.Repo
  alias CoverFlex.Accounts
  alias CoverFlex.Products.Product
  alias CoverFlex.Products.Order

  @spec list_products :: [Product.t()]
  @doc """
  List all products.
  """
  def list_products(), do: Repo.all(Product)

  @spec get_product(String.t()) :: {:error, :not_found} | {:ok, CoverFlex.Products.Product.t()}
  @doc """
  Get a product through the `id`.

  Returns {:ok, order} if successful, {:error, :not_found} if not.
  """
  def get_product(id) do
    case Repo.get(Product, id) do
      nil -> {:error, :not_found}
      %Product{} = product -> {:ok, product}
    end
  end

  def get_user_products(user_id) do
    user =
      Accounts.ensure_user(user_id)
      |> Repo.preload(orders: [:products])

    Enum.flat_map(user.orders, fn order -> order.products end)
    |> Enum.map(fn product -> product.id end)
  end

  @spec totalize_products([Product.t()]) :: integer()
  @doc """
  Reduces the prices of a list of `products` to a total.
  """
  def totalize_products(products) do
    Enum.reduce(products, 0, fn p, acc -> acc + p.price end)
  end

  @doc """
  Creates an order.

  Returns {:ok, order} if successful, {:error, changeset} if not.
  """
  def create_order(attrs \\ %{}) do
    Order.changeset(%Order{}, attrs)
    |> Repo.insert()
  end
end
