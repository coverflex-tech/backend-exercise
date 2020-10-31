defmodule CompanyBenefits.Orders do
  @moduledoc """
  The Orders API.
  """
  alias CompanyBenefits.Repo
  alias CompanyBenefits.Orders.{Order, OrderContext}
  alias CompanyBenefits.Products.ProductContext
  alias CompanyBenefits.Accounts.{User, UserContext}

  @doc """
  Creates order.
  """
  def create_order(%{identifiers: identifiers, username: username})
      when is_bitstring(username) and is_list(identifiers) do
    Repo.transaction(fn ->
      products = ProductContext.list_products_by_identifier(identifiers)

      with(
        %User{} = user <- UserContext.get_user_by_username(username),
        {:ok, %Order{} = order} <-
          OrderContext.create_order(%{
            user_id: user.id,
            products: products
          }),
        order <- Repo.preload(order, :products),
        {:ok, %User{}} <-
          UserContext.update_user(user, %{
            balance: user.balance - get_order_total(order)
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

  @doc """
  Sums product prices.
  """
  def get_order_total(%Order{} = order) do
    Repo.preload(order, :products)
    |> Map.get(:products, [])
    |> Enum.map(fn product -> product.price end)
    |> Enum.sum()
  end
end
