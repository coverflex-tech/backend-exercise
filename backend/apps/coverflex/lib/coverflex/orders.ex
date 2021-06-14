defmodule Coverflex.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Coverflex.Repo

  alias Coverflex.Orders.Order
  alias Coverflex.Accounts.User
  alias Coverflex.Accounts.UserAccount
  alias Coverflex.Accounts
  alias Coverflex.Products.Product
  alias Ecto.Multi

  @doc """
  Returns the list of orders.

  ## Examples

      iex> alias Coverflex.Orders.Order
      iex> import Coverflex.Orders
      iex> {:ok, user} = Coverflex.Accounts.create_user(%{user_id: "richardfeynman#{System.unique_integer([:positive])}"})
      iex> create_order(user)
      iex> [%Order{}] = list_orders()

  """
  def list_orders do
    Repo.all(Order)
    |> Repo.preload([:user])
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> alias Coverflex.Orders.Order
      iex> import Coverflex.Orders
      iex> {:ok, user} = Coverflex.Accounts.create_user(%{user_id: "richardfeynman#{System.unique_integer([:positive])}"})
      iex> {:ok, order} = create_order(user)
      iex> %Order{} = get_order!(order.id)

  """
  def get_order!(id), do: Repo.get!(Order, id) |> Repo.preload([:user])

  def buy_products(user_id, products) when is_binary(user_id) and is_list(products) do
    # Validate if user has enough balance to buy products
    # Validate if any product was previously bought
    # Update the order amount
    # Update the user balance
    buy_products_multi =
      Multi.new()
      |> Coverflex.Orders.Business.validate_if_user_has_enough_balance_to_buy_products(
        user_id,
        products
      )

    Repo.transaction(buy_products_multi)
  end

  def create_order(user_id) when is_binary(user_id) do
    user = Accounts.get_user!(user_id)
    create_order(user)
  end

  @doc """
  Creates a order.

  ## Examples

      iex> alias Coverflex.Orders.Order
      iex> import Coverflex.Orders
      iex> {:ok, user} = Coverflex.Accounts.create_user(%{user_id: "richardfeynman#{System.unique_integer([:positive])}" })
      iex> {:ok, %Order{}} = create_order(user)

  """
  def create_order(%User{} = user) do
    %Order{}
    |> Order.changeset()
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> alias Coverflex.Orders.Order
      iex> import Coverflex.Orders
      iex> {:ok, user} = Coverflex.Accounts.create_user(%{user_id: "richardfeynman#{System.unique_integer([:positive])}" })
      iex> {:ok, order} = create_order(user)
      iex> {:ok, %Order{}} = update_order(order, %{total: 100})

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> alias Coverflex.Orders.Order
      iex> import Coverflex.Orders
      iex> {:ok, user} = Coverflex.Accounts.create_user(%{user_id: "richardfeynman#{System.unique_integer([:positive])}" })
      iex> {:ok, order} = create_order(user)
      iex> {:ok, %Order{}} = delete_order(order)

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> alias Coverflex.Orders.Order
      iex> import Coverflex.Orders
      iex> order = %Order{total: 100}
      iex> %Ecto.Changeset{data: %Order{}} = change_order(order)

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  alias Coverflex.Orders.OrderItem

  @doc """
  Returns the list of order_items.

  ## Examples

      iex> list_order_items()
      [%OrderItem{}, ...]

  """
  def list_order_items do
    Repo.all(OrderItem) |> Repo.preload(order: :user)
  end

  @doc """
  Gets a single order_item.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{}

      iex> get_order_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item!(id), do: Repo.get!(OrderItem, id) |> Repo.preload(order: :user)

  @doc """
  Creates a order_item.

  ## Examples

      iex> create_order_item(%{field: value})
      {:ok, %OrderItem{}}

      iex> create_order_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item(attrs \\ %{}, order, product) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:order, order)
    |> Ecto.Changeset.put_assoc(:product, product)
    |> Repo.insert()
  end

  @doc """
  Updates a order_item.

  ## Examples

      iex> update_order_item(order_item, %{field: new_value})
      {:ok, %OrderItem{}}

      iex> update_order_item(order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item(%OrderItem{} = order_item, attrs) do
    order_item
    |> OrderItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order_item.

  ## Examples

      iex> delete_order_item(order_item)
      {:ok, %OrderItem{}}

      iex> delete_order_item(order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(%OrderItem{} = order_item) do
    Repo.delete(order_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item changes.

  ## Examples

      iex> alias Coverflex.Orders.OrderItem
      iex> change_order_item(%OrderItem{})
      %Ecto.Changeset{data: %OrderItem{}}

  """
  def change_order_item(%OrderItem{} = order_item, attrs \\ %{}) do
    OrderItem.changeset(order_item, attrs)
  end
end
