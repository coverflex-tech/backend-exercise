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

  def create_order(username, product_ids) do
    get_selected_products_query =
      from(
        p in Product,
        where: p.id in ^product_ids,
        select:  p
      )

    Repo.transaction(fn ->
      with user <- Repo.get_by(User, username: username),
           {:user_exists?, true} <- {:user_exists?, !is_nil(user)},
           {:products, products} <- {:products, Repo.all(get_selected_products_query)},
           {:products_exist?, true} <-
             {:products_exist?, length(product_ids) == length(products)},
           {:products_available?, true} <-
             {:products_available?, validate_product_availability(user.id, product_ids)},
           total_price <- Enum.reduce(products, 0, &(&1.price + &2)),
           {:user_has_balance?, true} <- {:user_has_balance?, total_price <= user.balance} do
        user_changeset = Ecto.Changeset.change(user, balance: user.balance - total_price)

        user = Repo.update!(user_changeset)

        order_changeset = Order.changeset(%{user: user, items: products})
        Repo.insert!(order_changeset)
      else
        {:user_exists?, false} -> Repo.rollback(:user_not_found)
        {:products_exist?, false} -> Repo.rollback(:products_not_found)
        {:products_available?, false} -> Repo.rollback(:products_already_purchased)
        {:user_has_balance?, false} -> Repo.rollback(:insufficient_balance)
      end
    end)
  end

  defp validate_product_availability(user_id, product_ids) do
    user_order_ids =
      from(
        o in Order,
        preload: :items,
        where: o.user_id == ^user_id
      )
      |> Repo.all()
      |> Enum.reduce([], fn order, acc ->
        order_items = Enum.map(order.items, & &1.id)

        Enum.concat(order_items, acc)
      end)

    !Enum.any?(user_order_ids, &(&1 in product_ids))
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
