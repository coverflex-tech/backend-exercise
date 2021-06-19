ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Coverflex.Repo, :manual)

alias Coverflex.Accounts
alias Coverflex.Products
alias Coverflex.Orders

defmodule Coverflex.TestHelper.Fixtures do
  def user_fixture(attrs \\ %{}, opts \\ []) do
    attrs =
      attrs
      |> Enum.into(%{user_id: "user#{System.unique_integer([:positive])}"})

    case(Keyword.get(opts, :with_account, false)) do
      true ->
        {:ok, user} = attrs |> Accounts.create_user_with_account()

        user

      false ->
        {:ok, user} = attrs |> Accounts.create_user()

        user
    end
  end

  def user_account_fixture(attrs \\ %{}) do
    attrs = Map.put_new(attrs, :balance, 0)
    user = user_fixture(attrs)

    {:ok, user_account} =
      attrs
      |> Accounts.create_user_account(user)

    user_account
  end

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "product#{System.unique_integer([:positive])}",
        price: System.unique_integer([:positive])
      })
      |> Products.create_product()

    product
  end

  def order_fixture() do
    {:ok, order} = user_fixture() |> Orders.create_order()

    order
  end
end
