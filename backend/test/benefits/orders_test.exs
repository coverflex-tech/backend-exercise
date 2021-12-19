defmodule Benefits.OrdersTest do
  use Benefits.DataCase

  import Benefits.ProductsFixtures
  import Benefits.UsersFixtures

  alias Benefits.Orders
  alias Benefits.Orders.Order

  setup do
    user = user_fixture()

    items =
      Enum.map(1..10, fn _ ->
        product = product_fixture()

        product.id
      end)

    {:ok, user: user, items: items}
  end

  describe "orders" do
    test "create_order/2 with valid data creates an order", %{
      user: user,
      items: items
    } do
      assert {:ok, %Order{} = order} = Orders.create_order(user.username, items)
      assert List.first(order.items).id == List.first(items)
    end

    test "create_order/2 fails if user not found", %{items: items} do
      assert {:error, :user_not_found} = Orders.create_order("Invalid user", items)
    end

    test "create_order/2 fails if one of the products in the list doesn't exist", %{
      user: user
    } do
      assert {:error, :products_not_found} = Orders.create_order(user.username, [1000])
    end

    test "create_order/2 fails if one of the products has already been purchased", %{
      user: user,
      items: items
    } do
      new_product = product_fixture()

      Orders.create_order(user.username, items)

      assert {:error, :products_already_purchased} =
               Orders.create_order(user.username, [new_product.id | items])
    end

    test "create_order/2 fails if user doesn't have enough balance" do
      user = user_fixture(balance: 1)
      product = product_fixture()

      assert {:error, :insufficient_balance} = Orders.create_order(user.username, [product.id])
    end
  end
end
