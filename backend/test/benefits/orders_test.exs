defmodule Benefits.OrdersTest do
  use Benefits.DataCase

  import Benefits.ProductsFixtures
  import Benefits.UsersFixtures

  alias Benefits.Orders
  alias Benefits.Orders.Order

  describe "orders" do
    test "create_order/2 with valid data creates an order" do
      user = user_fixture()
      product = product_fixture()

      assert {:ok, %Order{} = order} = Orders.create_order(user.username, [product.name])
      assert order.user.username == user.username
      assert order.user.balance == 0
      assert List.first(order.items).name == product.name
    end

    test "create_order/2 fails if user not found" do
      product = product_fixture()

      assert {:error, :user_not_found} = Orders.create_order("Invalid user", [product.name])
    end

    test "create_order/2 fails if one of the products in the list doesn't exist" do
      user = user_fixture()

      assert {:error, :products_not_found} = Orders.create_order(user.username, [user.username, "invalid products"])
    end

    test "create_order/2 fails if one of the products has already been purchased" do
      user = user_fixture()
      product = product_fixture()
      product2 = product_fixture(name: "Another Product")

      Orders.create_order(user.username, [product.name])

      assert {:error, :products_already_purchased} = Orders.create_order(user.username, [product.name, product2.name])
    end

    test "create_order/2 fails if user doesn't have enough balance" do
      user = user_fixture(balance: 1)
      product = product_fixture()

      assert {:error, :insuficient_balance} = Orders.create_order(user.username, [product.name])
    end
  end
end
