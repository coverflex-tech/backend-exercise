defmodule Backend.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Orders.{Item, Order}
  alias Backend.Users.User

  @doc """
  Returns the list of user orders.

  ## Examples

      iex> list_orders("test")
      [%Order{}, ...]

  """
  def list_orders(user_id) do
    from(o in Order, where: [user_id: ^user_id], order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Creates an order

  ## Examples

      iex> create_order(user, products)
      {:ok, {%Order{}, [%Item{}, ...]}

      iex> create_order(nil, products)
      {:error, "user_not_found"}

      iex> create_order(user, [])
      {:error, "products_not_found"}

  """
  def create_order(nil, _), do: {:error, "user_not_found"}
  def create_order(_user, []), do: {:error, "products_not_found"}

  def create_order(user, products) do
    with total <- products_total(products),
         {:ok, _} <- check_balance(user, total),
         {:ok, order} <- new_order(user, total),
         {:ok, items} <- create_items(order, user, products) do
      {:ok, {order, items}}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp products_total(products) do
    products
    |> Enum.map(fn p -> p.price end)
    |> Enum.reduce(fn price, acc -> price + acc end)
  end

  defp check_balance(user, total) when user.balance - total < 0,
    do: {:error, "insufficient_balance"}

  defp check_balance(user, total) when user.balance - total >= 0, do: {:ok, "sufficient_balance"}

  defp new_order(user, total) do
    %Order{}
    |> Order.changeset(%{total: total, user_id: user.user_id})
    |> Repo.insert()
  end

  defp create_items(order, user, products) do
    items_data =
      products
      |> Enum.map(fn p -> prepare_item(order, user, p) end)

    {_, items} = Repo.insert_all(Item, items_data, returning: true)
    {:ok, items}
  catch
    :error, %Postgrex.Error{postgres: %{code: :unique_violation}} ->
      {:error, "products_already_purchased"}

    _kind, _value ->
      {:error, "unexpected_error"}
  end

  defp prepare_item(order, user, product) do
    %{
      order_id: order.id,
      user_id: user.user_id,
      product_id: product.id,
      price: product.price,
      inserted_at: NaiveDateTime.local_now(),
      updated_at: NaiveDateTime.local_now()
    }
  end
end
