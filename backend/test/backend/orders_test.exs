defmodule Backend.OrdersTest do
  use Backend.DataCase

  alias Backend.Orders

  describe "orders" do
    import Backend.UsersFixtures

    test "create_order/2 with invalid user returns error" do
      assert {:error, "user_not_found"} = Orders.create_order(nil, [])
    end

    test "create_order/2 with empty products list returns error" do
      user = user_fixture()
      assert {:error, "products_not_found"} = Orders.create_order(user, [])
    end
  end
end
