defmodule Benefits.Orders.Commands do
  @moduledoc """
  Commands that interact with the order schema, producing side-effects.
  """
  alias Benefits.Orders
  alias Benefits.Orders.Order
  alias Benefits.Products
  alias Benefits.Repo
  alias Benefits.Users

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
      with {:ok, %{products: products, user: user}} <-
             fetch_products_and_user(product_ids, username),
           {:ok, total_price} <-
             validate_purchase_and_update_balance(
               user,
               products
             ),
           order <-
             do_create!(username, products, total_price) do
        order
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp fetch_products_and_user(product_ids, username) do
    with {:ok, products} <-
           Products.Queries.get_products(product_ids),
         {:ok, user} <-
           Users.Queries.get_user_by_username(username,
             lock_for_update?: true
           ) do
      {:ok, %{products: products, user: user}}
    else
      {:error, _reason} = result -> result
    end
  end

  defp validate_purchase_and_update_balance(user, products) do
    with :ok <- Orders.Queries.check_purchased(user, products),
         {:ok, total_price} <-
           Users.Queries.enough_balance?(user, products),
         _updated_user <-
           Users.Commands.decrease_user_balance!(user, total_price) do
      {:ok, total_price}
    else
      {:error, _reason} = result -> result
    end
  end

  defp do_create!(username, products, total_price) do
    %{user_id: username, products: products, total_price: total_price}
    |> Order.changeset()
    |> Repo.insert!()
  end
end
