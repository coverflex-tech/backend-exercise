defmodule Coverflex.OrdersTest do
  use Coverflex.DataCase
  #  doctest Coverflex.Orders

  alias Coverflex.{Orders, Accounts, Products}
  alias Coverflex.Accounts.User

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

  def order_fixture() do
    {:ok, order} = user_fixture() |> Orders.create_order()

    order
  end

  def order_item_fixture(attrs \\ %{}) do
    order = order_fixture()
    product = product_fixture()

    {:ok, order_item} =
      attrs
      |> Enum.into(%{price: product.price})
      |> Orders.create_order_item(order, product)

    order_item
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

  describe "orders" do
    alias Coverflex.Orders.Order

    @update_attrs %{total: 43}
    @invalid_attrs %{total: nil}

    test "list_orders/0 returns all orders" do
      assert length(Orders.list_orders()) == 2
    end

    test "get_order!/1 returns the order with given id" do
      %Order{id: order_id, user_id: user_id} = order_fixture()
      assert %Order{id: ^order_id, user_id: ^user_id} = Orders.get_order!(order_id)
    end

    test "create_order/1 with user schema creates a order" do
      user = user_fixture()
      assert {:ok, %Order{} = order} = Orders.create_order(user)
      assert order.total == 0
      assert order.user == user
    end

    test "create_order/1 with user id creates a order" do
      %User{id: user_id} = user_fixture()
      assert {:ok, %Order{} = order} = Orders.create_order(user_id)
      assert order.total == 0
      assert order.user.id == user_id
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
      %Order{id: order_id, user_id: user_id, total: total} = order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert %Order{id: ^order_id, user_id: ^user_id, total: ^total} = Orders.get_order!(order.id)
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

  describe "order_items" do
    alias Coverflex.Orders.OrderItem

    @valid_attrs %{price: System.unique_integer([:positive])}
    @update_attrs %{}

    test "list_order_items/0 returns all order_items" do
      assert length(Orders.list_order_items()) == 2
    end

    test "get_order_item!/1 returns the order_item with given id" do
      %OrderItem{id: order_item_id, order_id: order_id} = order_item_fixture()

      assert %OrderItem{id: ^order_item_id, order_id: ^order_id} =
               Orders.get_order_item!(order_item_id)
    end

    test "create_order_item/1 with valid data creates a order_item" do
      product = product_fixture()
      order = order_fixture()
      assert {:ok, %OrderItem{}} = Orders.create_order_item(@valid_attrs, order, product)
    end

    #    test "create_order_item/1 with invalid data returns error changeset" do
    #      assert {:error, %Ecto.Changeset{}} = Orders.create_order_item(@invalid_attrs)
    #    end

    test "update_order_item/2 with valid data updates the order_item" do
      order_item = order_item_fixture()

      assert {:ok, %OrderItem{}} = Orders.update_order_item(order_item, @update_attrs)
    end

    #    test "update_order_item/2 with invalid data returns error changeset" do
    #      order_item = order_item_fixture()
    #      IO.inspect(order_item, label: "Order item")
    #      assert {:error, %Ecto.Changeset{}} = Orders.update_order_item(order_item, @invalid_attrs)
    #      assert order_item == Orders.get_order_item!(order_item.id)
    #    end

    test "delete_order_item/1 deletes the order_item" do
      order_item = order_item_fixture()
      assert {:ok, %OrderItem{}} = Orders.delete_order_item(order_item)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order_item!(order_item.id) end
    end

    test "change_order_item/1 returns a order_item changeset" do
      order_item = order_item_fixture()
      assert %Ecto.Changeset{} = Orders.change_order_item(order_item)
    end

    test "buy_products/2 validate if user without enough balance receives an error" do
      product = product_fixture()
      user = user_fixture(%{}, with_account: true)
      products = [product.id]
      {:error, :check_balance, message, _data} = Orders.buy_products(user.user_id, products)

      assert message == "you do not have enough balance to buy the selected products"
    end
  end
end
