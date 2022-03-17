defmodule Benefits.Users.QueriesTest do
  use Benefits.DataCase, async: true

  import Benefits.Factory

  alias Benefits.Users.Queries

  describe "get_user_by_username/1" do
    setup do
      username = "Redrum"
      insert(:user, username: username)

      %{username: username}
    end

    test "returns {:ok, user} when one user is found", ctx do
      assert {:ok, user} = Queries.get_user_by_username(ctx.username)
      assert user.username == ctx.username
    end

    test "returns {:error, :user_not_found} when no user is found", _ctx do
      assert {:error, :user_not_found} == Queries.get_user_by_username("Murder")
    end

    test "is case-sensitive", ctx do
      username = String.downcase(ctx.username)
      assert {:error, :user_not_found} == Queries.get_user_by_username(username)
    end
  end

  describe "enough_balance?/2" do
    setup do
      user = insert(:user, balance: 3)
      products = build_list(3, :product, price: 1)

      %{user: user, products: products}
    end

    test "returns {:ok, total_price} when user has enough funds", ctx do
      assert {:ok, total_price} = Queries.enough_balance?(ctx.user, ctx.products)
      assert total_price == Enum.reduce(ctx.products, 0, &(&1.price + &2))
    end

    test "returns {:error, :insufficient_balance} when user does not have enough funds", ctx do
      user = insert(:user, balance: 0)

      assert {:error, :insufficient_balance} ==
               Queries.enough_balance?(user, ctx.products)
    end
  end
end
