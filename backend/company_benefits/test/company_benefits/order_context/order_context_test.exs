defmodule CompanyBenefits.Orders.OrderContextTest do
  use CompanyBenefits.DataCase

  alias CompanyBenefits.Accounts
  alias CompanyBenefits.Products.ProductContext
  alias CompanyBenefits.Orders.OrderContext

  describe "orders" do
    alias CompanyBenefits.Orders.Order

    @invalid_attrs %{user_id: nil, products: [], total: nil}

    def user_fixture(username \\ "some username") do
      {:ok, user} = Accounts.login(username)
      user
    end

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(%{
          identifier: "product",
          name: "product",
          price: 10
        })
        |> ProductContext.create_product()

      product
    end

    def order_fixture(attrs \\ %{}) do
      user = user_fixture()
      product = product_fixture()

      {:ok, order} =
        attrs
        |> Map.put_new(:user_id, user.id)
        |> Map.put_new(:products, [product])
        |> Map.put_new(:total, product.price)
        |> OrderContext.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert OrderContext.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert OrderContext.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      user = user_fixture("username")
      product = product_fixture()

      assert {:ok, %Order{} = order} =
               OrderContext.create_order(%{
                 user_id: user.id,
                 products: [product],
                 total: product.price
               })

      assert order.user_id == user.id
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrderContext.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      user = user_fixture("updated username")
      order = order_fixture()
      assert {:ok, order} = OrderContext.update_order(order, %{user_id: user.id})
      assert %Order{} = order
      assert order.user_id == user.id
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = OrderContext.update_order(order, @invalid_attrs)
      assert order == OrderContext.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = OrderContext.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> OrderContext.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = OrderContext.change_order(order)
    end
  end
end
