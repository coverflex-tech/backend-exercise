defmodule Backend.OrdersTest do
  use Backend.DataCase

  alias Backend.Orders
  alias Backend.Orders.{Item, Order}

  describe "orders" do
    import Backend.{ProductsFixtures, UsersFixtures}

    test "create_order/2 with invalid user returns error" do
      assert {:error, "user_not_found"} = Orders.create_order(nil, [])
    end

    test "create_order/2 with empty products list returns error" do
      user = user_fixture()
      assert {:error, "products_not_found"} = Orders.create_order(user, [])
    end

    test "create_order/2 with insufficient balance returns error" do
      user = user_fixture(%{balance: 500})
      products = [product_fixture(%{price: 300}), product_fixture(%{price: 300})]
      assert {:error, "insufficient_balance"} = Orders.create_order(user, products)
    end
  end
end
