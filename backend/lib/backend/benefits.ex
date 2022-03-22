defmodule Backend.Benefits do
  @moduledoc """
  The Benefits context.
  """

  alias Backend.Repo
  alias Backend.Benefits.{Order, User}
  alias Backend.Benefits.Products.Query, as: ProductQuery
  alias Backend.Benefits.Products.Product
  alias Ecto.Multi

  @default_balance 500_00

  @doc """
  Gets a single user by username, or creates a new with default values.
  """
  def get_or_create_user(%{username: nil}), do: {:error, :username_cant_be_nil}

  def get_or_create_user(%{username: username}) do
    case Repo.get_by(User, username: username) do
      nil -> create_user(%{username: username, balance: @default_balance})
      user -> {:ok, user}
    end
  end

  defp create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of products.
  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Creates a product.
  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an order.
  """
  def create_order(%{items: product_string_ids, user_id: username}) do
    with {:ok, user} <- get_or_create_user(%{username: username}),
         {:ok, products} <- get_products_by_string_ids(product_string_ids),
         {:ok, :products_never_bought_by_user} <-
           check_user_bought_products(user, product_string_ids) do
      total_value = sum_product_prices(products)
      attrs = %{user: user, products: products, total_value: total_value}

      user_changeset = User.changeset(user, %{balance: user.balance - total_value})
      order_changeset = Order.changeset(%Order{}, attrs)

      do_create_order(user_changeset, order_changeset)
    end
  end

  defp do_create_order(user_changeset, order_changeset) do
    Multi.new()
    |> Multi.update(:user, user_changeset)
    |> Multi.insert(:order, order_changeset)
    |> Repo.transaction()
    |> case do
      {:ok, %{order: order}} ->
        {:ok, order}

      {:error, :user, %{errors: [balance: _]}, _} ->
        {:error, :insufficient_balance}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  defp get_products_by_string_ids(product_string_ids) when is_list(product_string_ids) do
    found_products =
      Product
      |> ProductQuery.filter_by_product_string_ids_list(product_string_ids)
      |> Repo.all()

    if(length(found_products) == length(product_string_ids)) do
      {:ok, found_products}
    else
      {:error, :products_not_found}
    end
  end

  defp get_products_by_string_ids(_), do: {:error, :invalid_order}

  defp check_user_bought_products(user, product_string_ids) do
    user
    |> ProductQuery.products_bought_by_user_query()
    |> ProductQuery.filter_by_product_string_ids_list(product_string_ids)
    |> Repo.aggregate(:count)
    |> case do
      0 -> {:ok, :products_never_bought_by_user}
      _ -> {:error, :products_already_purchased}
    end
  end

  defp sum_product_prices(products) do
    products
    |> Enum.map(& &1.price)
    |> Enum.sum()
  end
end
