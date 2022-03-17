defmodule Benefits.Orders.QueriesTest do
  use Benefits.DataCase, async: true

  import Benefits.Factory

  alias Benefits.Orders.Queries

  describe "check_purchased/2" do
    setup do
      products = build_list(3, :product)
      user = insert(:user)
      insert(:order, user_id: user.username, products: products)

      %{products: products, user: user}
    end

    test "returns :ok if products to be purchased haven't been purchased", ctx do
      new_product = build(:product)
      assert :ok == Queries.check_purchased(ctx.user, [new_product])
    end

    test "returns {:error, :products_already_purchased} if at least one product" <>
           " to be purchased has already been purchased",
         ctx do
      already_purchased_product = Enum.random(ctx.products)

      assert {:error, :products_already_purchased} ==
               Queries.check_purchased(ctx.user, [already_purchased_product])
    end
  end
end
