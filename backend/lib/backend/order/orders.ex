defmodule Benefits.Orders do
  @moduledoc """
  The `Orders` context.
  It provides direct actions with `Order` schema and `orders` table.
  """
  alias Benefits.Order
  alias Benefits.Products
  alias Benefits.Repo
  alias Benefits.Users

  @doc """
  Creates a new order after doing some checks if the user is able to proceed.

  The checks are the following:
  > Checks if the user has already bought any of the products in the past.
  > Checks if all the procuts the user is trying to buy exist.
  > Checks if the user has the balance to make the purchase.

  ### Examples

    iex> Benefits.Orders.create("existing_username", ["product_a", "product_b"])
    {:ok, %Order{}}

    iex> Benefits.Orders.create("existing_username", ["product_a", "product_b"])
    {:error, "insufficient_balance"}

    iex> Benefits.Orders.create("existing_username", ["product_a", "product_b"])
    {:error, "products_not_found"}

    iex> Benefits.Orders.create("existing_username", ["product_a", "product_b"])
    {:error, "products_already_purchased"}

  """
  def create(username, products_identifiers) do
    products_identifiers = Enum.uniq(products_identifiers)

    with {:ok, products} <- Products.list(products_identifiers),
         {:ok, user} <- Users.get_by_username(username),
         {:ok, _succ} <- check_products_existence(products_identifiers, products),
         {:ok, _succ} <- check_already_bought(user.products, products),
         {:ok, total} <- Products.sum_products_prices(products),
         {:ok, _succ} <- check_balance(user.balance, total),
         {:ok, order} <- create_aux(%{user_id: user.id, total: total, products: products}),
         {:ok, _user} <- Users.update(user, %{balance: user.balance - total, products: products}) do
      {:ok, order}
    else
      {:error, error} -> {:error, error}
    end
  end

  #
  # Verifies if user has sufficient_balance to procceed with the order
  #
  defp check_balance(balance, cost) when balance >= cost, do: {:ok, "succ"}
  defp check_balance(_, _), do: {:error, "insufficient_balance"}

  #
  # Verifies if user has ordered non existing products
  #
  defp check_products_existence(ordered_products, found_products)
       when length(ordered_products) == length(found_products),
       do: {:ok, "succ"}

  defp check_products_existence(_, _), do: {:error, "products_not_found"}

  #
  # Checks if the user already has bought the items
  #
  defp check_already_bought(user_products, order_products)
       when user_products == [] or order_products == [],
       do: {:ok, :succ}

  defp check_already_bought(user_products, order_products) do
    user_products
    |> Enum.find(&Enum.member?(order_products, &1))
    |> case do
      nil -> {:ok, :succ}
      _ -> {:error, "products_already_purchased"}
    end
  end

  #
  # Creates a new order with given `attrs`
  #
  defp create_aux(attrs) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end
end
