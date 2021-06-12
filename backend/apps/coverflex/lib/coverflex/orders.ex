defmodule Coverflex.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Coverflex.Repo

  alias Coverflex.Orders.Order
  alias Coverflex.Accounts.User
  alias Coverflex.Accounts

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
    |> Order.changeset(%{})
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
end
