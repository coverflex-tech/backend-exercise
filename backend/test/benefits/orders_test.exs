defmodule Benefits.OrdersTest do
  use Benefits.DataCase

  alias Benefits.Orders

  describe "orders" do
    import Benefits.{UsersFixtures, ProductsFixtures}

    test "create_order/1 with valid data creates a order" do
      user = user_fixture(%{user_id: "rafa", balance: Decimal.new("500")})
      product1 = product_fixture(%{name: "Hulu", price: Decimal.new("74.99")})
      product2 = product_fixture(%{name: "Disney+", price: Decimal.new("18.23")})

      valid_attrs = %{user_id: user.user_id, items: [product1.id, product2.id]}

      assert {:ok, %{order: order}} = Orders.create_order(valid_attrs)
      assert order.user_id == "rafa"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, :order, %Ecto.Changeset{} = changeset, %{}} = Orders.create_order(%{user_id: nil})
      assert errors_on(changeset) == %{items: ["can't be blank"], user_id: ["can't be blank"]}
    end
  end
end
