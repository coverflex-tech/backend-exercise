defmodule CompanyBenefits.Orders do
  @moduledoc """
  The Orders API.
  """
  alias CompanyBenefits.Repo
  alias CompanyBenefits.Orders.{Order, OrderContext}
  alias CompanyBenefits.Products.ProductContext
  alias CompanyBenefits.Products
  alias CompanyBenefits.Accounts.{User, UserContext}

  @doc """
  Creates order.
  """
  def create_order(%{identifiers: identifiers, username: username})
      when is_bitstring(username) and is_list(identifiers) do
    # validate products already bought
    Repo.transaction(fn ->
      with(
        {:ok, {products, total}} <- validate_products(identifiers),
        %User{} = user <- UserContext.get_user_by_username(username),
        {:ok, newBalance} <- deduct_funds(user, total),
        {:ok, %Order{} = order} <-
          OrderContext.create_order(%{
            user_id: user.id,
            products: products,
            total: total
          }),
        {:ok, %User{}} <-
          UserContext.update_user(user, %{
            balance: newBalance
          })
      ) do
        {:ok, Repo.preload(order, :products)}
      else
        nil ->
          Repo.rollback({:error, :user_not_found})

        error ->
          Repo.rollback(error)
      end
    end)
    |> elem(1)
  end

  defp validate_products(identifiers) do
    products = ProductContext.list_products_by_identifier(identifiers)
    total = Products.sum_prices(products)

    if length(identifiers) == length(products) do
      {:ok, {products, total}}
    else
      {:error, :products_not_found}
    end
  end

  defp deduct_funds(%User{balance: balance}, total) do
    if(balance >= total) do
      {:ok, balance - total}
    else
      {:error, :insufficient_balance}
    end
  end
end
