defmodule Coverflex.OrdersTest do
  use Coverflex.DataCase
  doctest Coverflex.Orders

  alias Coverflex.{Orders, Accounts}

  describe "orders" do
    alias Coverflex.Orders.Order

    @update_attrs %{total: 43}
    @invalid_attrs %{total: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{user_id: "user#{System.unique_integer([:positive])}"})
        |> Accounts.create_user()

      user
    end

    def order_fixture() do
      {:ok, order} = user_fixture() |> Orders.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with user schema creates a order" do
      user = user_fixture()
      assert {:ok, %Order{} = order} = Orders.create_order(user)
      assert order.total == 0
      assert order.user == user
    end

    test "create_order/1 with user id creates a order" do
      user = user_fixture()
      assert {:ok, %Order{} = order} = Orders.create_order(user.id)
      assert order.total == 0
      assert order.user == user
    end

    test "create_order/1 with non existent user" do
      assert_raise Ecto.NoResultsError, fn ->
        Orders.create_order("31ae098b-9354-4d1f-882c-8f609a7a5c7c")
      end
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, %Order{} = order} = Orders.update_order(order, @update_attrs)
      assert order.total == 43
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
