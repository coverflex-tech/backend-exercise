defmodule Benefits.Orders.Commands do
  @moduledoc """
  Commands that interact with the order schema, producing side-effects.
  """
  alias Benefits.Orders
  alias Benefits.Orders.Order
  alias Benefits.Products
  alias Benefits.Users
  alias Benefits.Repo

  @spec create_order(%{items: [String.t()], user_id: String.t()}) ::
          {:ok, Order.t()}
          | {:error,
             :products_not_found
             | :user_not_found
             | :products_already_purchased
             | :insufficient_balance
             | :unexpected_error}

  @doc """
  Creates an order.
  """
  def create_order(%{items: product_ids, user_id: username}) do
    Repo.transaction(fn ->
      with {:ok, products} <-
             Products.Queries.get_products(product_ids),
           {:ok, user} <-
             Users.Queries.get_user_by_username(username,
               lock_for_update?: true
             ),
           :ok <-
             Orders.Queries.check_purchased(user, products),
           {:ok, total_price} <-
             Users.Queries.enough_balance?(user, products),
           _updated_user <-
             Users.Commands.decrease_user_balance!(user, total_price),
           order <-
             do_create!(username, products, total_price) do
        order
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp do_create!(username, products, total_price) do
    %{user_id: username, products: products, total_price: total_price}
    |> Order.changeset()
    |> Repo.insert!()
  end
end
