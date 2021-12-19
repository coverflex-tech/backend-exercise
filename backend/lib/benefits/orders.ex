defmodule Benefits.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false

  alias Benefits.Orders.Order
  alias Benefits.Products.Product
  alias Benefits.Repo
  alias Benefits.Users.User

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Creates an order by recieving the username and the product names.

  ## Examples

      iex> create_order("User name", ["Product 1", "Product 2"])
      {:ok, %Order{}}

      iex> create_order("Non existing user", []})
      {:error, :products_not_found}

  """
  @spec create_order(binary(), list(binary())) ::
          {:ok, Order.t()}
          | {:error,
             :user_not_found
             | :products_not_found
             | :products_already_purchased
             | :insufficient_balance}
  def create_order(_, []), do: {:error, :products_not_found}

  def create_order(username, product_names) do
    list_products_query =
      from(
        p in Product,
        where: p.name in ^product_names
      )

    Repo.transaction(fn ->
      with user <- Repo.get_by(User, username: username),
           {:user_exists?, true} <- {:user_exists?, !is_nil(user)},
           {:products, products} <- {:products, Repo.all(list_products_query)},
           {:products_exist?, true} <-
             {:products_exist?, length(product_names) == length(products)},
           {:products_available?, true} <-
             {:products_available?, Enum.all?(products, &is_nil(&1.order_id))},
           total_price <- Enum.reduce(products, 0, &(&1.price + &2)),
           {:user_has_balance?, true} <- {:user_has_balance?, total_price <= user.balance} do
        user_changeset = Ecto.Changeset.change(user, balance: user.balance - total_price)

        user = Repo.update!(user_changeset)

        Repo.insert!(%Order{user: user, items: products})
      else
        {:user_exists?, false} -> Repo.rollback(:user_not_found)
        {:products_exist?, false} -> Repo.rollback(:products_not_found)
        {:products_available?, false} -> Repo.rollback(:products_already_purchased)
        {:user_has_balance?, false} -> Repo.rollback(:insufficient_balance)
      end
    end)
  end

  @doc """
  Gets an order's info.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)
end
