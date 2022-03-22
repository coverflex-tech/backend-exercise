defmodule Backend.Orders.CreateTest do
  use Backend.DataCase, async: false
  use Builders

  alias Backend.Orders
  alias Backend.Orders.Schemas.Order
  alias Backend.Users

  describe "call/1" do
    test "should return an Order if all params of one Order are valid and user has enough balance" do
      create_product(id: "netflix", price: Decimal.new("10.00"))
      create_user(id: "frodo", balance: Decimal.new("11.00"))

      params = %{user_id: "frodo", order_items: ["netflix"]}

      result = Orders.Create.call(params)
      user = Users.Get.call("frodo")

      assert {:ok, %Order{} = order} = result
      assert Decimal.eq?(user.balance, "1.00")
      assert Decimal.eq?(order.total, "10.00")
    end

    test "should return an Order if all params of many Order are valid and user has enough balance" do
      create_product(id: "netflix", price: Decimal.new("10.00"))
      create_product(id: "spotify", price: Decimal.new("15.00"))
      create_product(id: "youtube", price: Decimal.new("10.00"))
      create_user(id: "frodo", balance: Decimal.new("41.00"))

      params = %{user_id: "frodo", order_items: ["netflix", "spotify", "youtube"]}

      result = Orders.Create.call(params)
      user = Users.Get.call("frodo")

      assert {:ok, %Order{} = order} = result
      assert Decimal.eq?(user.balance, "6.00")
      assert Decimal.eq?(order.total, "35.00")
    end

    test "should return an Order if all params of one Order are valid and user has enough balance only for this order" do
      create_product(id: "netflix", price: Decimal.new("10.00"))
      create_product(id: "spotify", price: Decimal.new("15.00"))
      create_user(id: "frodo", balance: Decimal.new("25.00"))

      params = %{user_id: "frodo", order_items: ["netflix", "spotify"]}

      result = Orders.Create.call(params)
      user = Users.Get.call("frodo")

      assert {:ok, %Order{} = order} = result
      assert Decimal.eq?(user.balance, "0.00")
      assert Decimal.eq?(order.total, "25.00")
    end

    test "should return a {:error, :insufficient_balance} if user doesn`t have enough balance" do
      create_product(id: "netflix", price: Decimal.new("10.00"))
      create_user(id: "frodo", balance: Decimal.new("09.00"))

      params = %{user_id: "frodo", order_items: ["netflix"]}

      result = Orders.Create.call(params)

      assert {:error, :insufficient_balance} = result
    end

    test "should return a {:error, :products_already_purchased} if user already purchased a product" do
      create_product(id: "netflix", price: Decimal.new("10.00"))
      create_user(id: "frodo1", balance: Decimal.new("39.00"))

      params = %{user_id: "frodo1", order_items: ["netflix"]}
      {:ok, _} = Orders.Create.call(params)

      result = Orders.Create.call(params)

      assert {:error, :products_already_purchased} = result
    end
  end
end
