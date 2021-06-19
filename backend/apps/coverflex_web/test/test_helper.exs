alias Coverflex.{Products, Accounts}

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Coverflex.Repo, :manual)

defmodule TestHelper.CoverflexWeb.Fixtures do
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
end
