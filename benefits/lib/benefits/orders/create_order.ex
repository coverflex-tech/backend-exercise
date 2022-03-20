defmodule Benefits.Orders.CreateOrder do
  @moduledoc "Command for creating a new order"

  import Ecto.Query

  require Logger

  alias Benefits.{Repo, User, Wallet}
  alias Benefits.Orders.{CreateOrderInput, Order, OrderProduct, Product}

  @doc """
  Creates a new order

  This function fails if:

  - the user doesn't exist
  - the user doesn't have enough balance or
  - the order contains items previously bought or
  - one or more items doesn't point to an existing product
  """
  @spec perform(input :: CreateOrderInput.t()) ::
          {:ok, Order.t()}
          | {:error,
             :user_not_found
             | :products_not_found
             | :insufficient_balance
             | :products_already_purchased}
  def perform(%CreateOrderInput{} = input) do
    Logger.metadata(user_id: input.user_id, items: input.items)

    Repo.transaction(fn ->
      with {:ok, user} <- get_user(input.user_id),
           {:ok, wallet} <- get_and_lock_wallet(user.id),
           {:ok, products} <- get_products(input.items),
           {:ok, total_price} <- calculate_total_price(products),
           :ok <- check_if_the_products_exist(products, input),
           :ok <- check_if_has_enough_balance(wallet, total_price),
           :ok <- check_for_already_purchased_products(user.id, products),
           {:ok, order} <- create_order(user, products, total_price),
           {:ok, _wallet} <- debit_from_wallet(wallet, total_price) do
        order
      else
        {:error, reason} ->
          Logger.info("Failed to create the order", reason: inspect(reason))
          Repo.rollback(reason)
      end
    end)
  end

  defp get_user(user_id) do
    User
    |> where([u], u.username == ^user_id)
    |> Repo.one()
    |> case do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  defp get_and_lock_wallet(user_id) do
    {:ok,
     Wallet
     |> where([w], w.user_id == ^user_id)
     |> lock("FOR UPDATE")
     |> Repo.one()}
  end

  defp get_products(product_ids) do
    {:ok,
     Product
     |> where([p], p.id in ^product_ids)
     |> Repo.all()}
  end

  defp calculate_total_price(products) do
    {:ok, Enum.reduce(products, Money.new(0), &Money.add(&1.price, &2))}
  end

  defp check_if_the_products_exist(loaded_products, input) do
    loaded_product_ids = MapSet.new(loaded_products, & &1.id)

    input.items
    |> MapSet.new()
    |> MapSet.equal?(loaded_product_ids)
    |> case do
      true -> :ok
      false -> {:error, :products_not_found}
    end
  end

  defp check_if_has_enough_balance(wallet, total_price) do
    if Money.cmp(wallet.amount, total_price) in [:gt, :eq] do
      :ok
    else
      {:error, :insufficient_balance}
    end
  end

  defp check_for_already_purchased_products(user_id, products) do
    Order
    |> where([o], o.user_id == ^user_id)
    |> join(:inner, [o], op in OrderProduct, on: op.order_id == o.id)
    |> where([_o, op], op.product_id in ^Enum.map(products, & &1.id))
    |> Repo.exists?()
    |> case do
      true -> {:error, :products_already_purchased}
      false -> :ok
    end
  end

  defp create_order(user, products, total_price) do
    %{
      user_id: user.id,
      price: total_price
    }
    |> Order.changeset(products)
    |> Repo.insert()
  end

  defp debit_from_wallet(wallet, amount) do
    wallet
    |> Wallet.changeset(%{amount: Money.subtract(wallet.amount, amount)})
    |> Repo.update()
  end
end
