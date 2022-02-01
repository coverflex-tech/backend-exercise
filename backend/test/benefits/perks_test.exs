defmodule Benefits.PerksTest do
  use Benefits.DataCase

  alias Benefits.Perks

  describe "products" do
    alias Benefits.Perks.Product

    @valid_attrs %{identifier: "some identifier", name: "some name", price: 120.5}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Perks.create_product()

      product
    end

    test "create_product/1 with valid data creates a product" do
      attrs = %{identifier: "create_identifier", name: "create_name", price: 120.5}

      assert {:ok, %Product{} = product} = Perks.create_product(attrs)
      assert product.identifier == "create_identifier"
      assert product.name == "create_name"
      assert product.price == 120.5
    end

    test "create_product/1 with invalid identifier returns error changeset" do
      invalid_attrs = %{identifier: nil, name: "invalid_name", price: 5.0}
      assert {:error, %Ecto.Changeset{}} = Perks.create_product(invalid_attrs)
    end

    test "create_product/1 with duplicated identifier returns error changeset" do
      attrs = %{identifier: "duplicated_identifier", name: "duplicated_name", price: 120.5}
      assert {:ok, %Product{}} = Perks.create_product(attrs)
      assert {:error, %Ecto.Changeset{}} = Perks.create_product(attrs)
    end

    test "create_product/1 with invalid name returns error changeset" do
      invalid_attrs = %{identifier: "invalid_identifier", name: nil, price: 5.0}
      assert {:error, %Ecto.Changeset{}} = Perks.create_product(invalid_attrs)
    end

    test "create_product/1 with invalid price returns error changeset" do
      invalid_attrs = %{identifier: "invalid_identifier", name: "invalid_name", price: -5.0}
      assert {:error, %Ecto.Changeset{}} = Perks.create_product(invalid_attrs)
    end

    test "list_products/0 returns all products" do
      assert Perks.list_products() == []

      product1 = product_fixture(%{identifier: "product1", name: "Product1", price: 120.5})
      product2 = product_fixture(%{identifier: "product2", name: "Product2", price: 12.5})
      product3 = product_fixture(%{identifier: "product3", name: "Product3", price: 1.5})
      product4 = product_fixture(%{identifier: "product4", name: "Product4", price: 0.5})
      product5 = product_fixture(%{identifier: "product5", name: "Product5", price: 0.1})

      products = Perks.list_products()

      assert is_list(products)
      assert product1 in products
      assert product2 in products
      assert product3 in products
      assert product4 in products
      assert product5 in products
    end
  end

  describe "orders" do
    alias Benefits.Accounts

    @not_found {:error, "products_not_found"}
    @inexistent_user {:error, "Inexistent User"}

    setup do
      # create 3 products
      Perks.create_product(%{identifier: "product1", name: "Product1", price: 120.5})
      Perks.create_product(%{identifier: "product2", name: "Product2", price: 12.5})
      Perks.create_product(%{identifier: "product3", name: "Product3", price: 1.5})

      # create two user
      Accounts.create_user(%{balance: 130.0, user_id: "user1"})
      Accounts.create_user(%{balance: 150.0, user_id: "user2"})

      :ok
    end

    test "create_order/2 with invalid identifier list returns '{:error, 'products_not_found'}" do
      assert Perks.create_order("inexistent1", "user1") == @not_found
      assert Perks.create_order([], "user1") == @not_found
      assert Perks.create_order(["inexistent1"], "user1") == @not_found
      assert Perks.create_order(["inexistent1", "inexistent2"], "user1") == @not_found
      assert Perks.create_order(["product1", "inexistent1"], "user1") == @not_found
    end

    test "create_order/2 with invalid user returns '{:error, 'Inexistent User'}" do
      assert Perks.create_order(["product1"], "inexistent") == @inexistent_user
      assert Perks.create_order(["product1", "product2"], "user3") == @inexistent_user
    end

    test "create_order/2 with total price higher than user's balance returns '{:error, 'insufficient_balance'}" do
      assert Perks.create_order(["product1", "product2"], "user1") ==
               {:error, "insufficient_balance"}
    end

    test "create_order/2 with repeated products returns '{:error, 'products_already_purchased'}" do
      Perks.create_order(["product2"], "user1")
      assert Perks.create_order(["product2"], "user1") == {:error, "products_already_purchased"}
    end

    test "create_order/2 with valid data, creates an Order, an OrderLine and updates the user's balance" do
      identifiers = ["product2", "product3"]
      user_id = "user2"

      {:ok,
       %{
         order_id: _order_id,
         total: order_total,
         items: order_items
       }} = Perks.create_order(identifiers, user_id)

      user = Accounts.get_user(user_id)
      user_products = Enum.map(user.products, & &1.identifier)

      assert order_total == 12.5 + 1.5
      assert user.balance == 150.0 - order_total
      assert identifiers == order_items
      assert order_items == user_products
    end
  end
end
