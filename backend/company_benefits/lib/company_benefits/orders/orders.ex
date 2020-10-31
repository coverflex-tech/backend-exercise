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
    # vaidate suficient balance
    # validate products found
    # validate products already bought
    Repo.transaction(fn ->
      products = ProductContext.list_products_by_identifier(identifiers)
      total = Products.sum_prices(products)

      with(
        %User{} = user <- UserContext.get_user_by_username(username),
        {:ok, %Order{} = order} <-
          OrderContext.create_order(%{
            user_id: user.id,
            products: products,
            total: total
          }),
        order <- Repo.preload(order, :products),
        {:ok, %User{}} <-
          UserContext.update_user(user, %{
            balance: user.balance - total
          })
      ) do
        {:ok, order}
      else
        nil ->
          Repo.rollback({:error, :user_not_found})

        error ->
          Repo.rollback(error)
      end
    end)
    |> elem(1)
  end
end
