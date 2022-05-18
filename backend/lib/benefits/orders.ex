defmodule Benefits.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Benefits.Repo

  alias Benefits.Orders.{Order, OrderProduct}
  alias Benefits.Users

  @doc """
  Creates an order, deduces the order total from the user balance and saves the order items.

  Validates:
    - Order required fields (user_id and at least 1 item)
    - User balance is enough to purchase order items
    - User hasn't already purchased these products
    - All order items are existing products
  """
  def create_order(attrs) do
    Repo.transaction(fn ->
      with {:ok, order} <- do_create_order(attrs),
           {:ok, _user} <- Users.pay_for_order(order),
           {:ok, _order_products} <- create_order_products(order) do
        order
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
    |> case do
      {:error, changeset} -> {:error, get_special_message(changeset)}
      result -> result
    end
  end

  def get_special_message(changeset) do
    case changeset do
      %Changeset{errors: [user_id: {"products_already_purchased", _}]} ->
        "products_already_purchased"

      %Changeset{errors: [balance: {"insufficient_balance", _}]} ->
        "insufficient_balance"

      %Changeset{errors: [product_id: {"products_not_found", _}]} ->
        "products_not_found"

      changeset ->
        changeset
    end
  end

  def create_order_products(order) do
    result =
      Enum.reduce_while(order.items, [], fn item, acc ->
        attrs = %{
          user_id: order.user_id,
          order_id: order.id,
          product_id: item
        }

        case create_order_product(attrs) do
          {:ok, order_product} -> {:cont, [order_product | acc]}
          {:error, changeset} -> {:halt, {:error, changeset}}
        end
      end)

    case result do
      order_products when is_list(order_products) ->
        {:ok, order_products}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_order_product(attrs) do
    %OrderProduct{}
    |> OrderProduct.changeset(attrs)
    |> Repo.insert()
  end

  defp do_create_order(attrs) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end
end
