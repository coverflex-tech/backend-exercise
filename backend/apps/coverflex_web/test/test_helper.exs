alias Coverflex.{Products, Accounts}

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Coverflex.Repo, :manual)

defmodule TestHelper.Fixtures do
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

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{user_id: "user#{System.unique_integer([:positive])}"})
      |> Accounts.create_user()

    user
  end
end
