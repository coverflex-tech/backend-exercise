defmodule Backend.OrderTest do
  use Backend.DataCase, async: true
  alias Backend.{Product, Order, User, Repo}

  describe "create/2" do
    test "returns {:ok, %Order{}} if it is able to create a user order" do
      user_id = "user_id"
      Repo.insert!(%User{user_id: user_id, data: %User.Data{}})

      product_id_1 = "product_id_1"
      product_id_2 = "product_id_2"

      Repo.insert!(%Product{id: product_id_1, name: "Product 2", price: 10})
      Repo.insert!(%Product{id: product_id_2, name: "Product 2", price: 10})

      items = [product_id_1, product_id_2]

      assert {:ok,
              %Order{order_id: id, data: %Order.Data{user_id: ^user_id, total: 20, items: ^items}}} =
               Order.create(user_id, items)

      assert {:ok, _} = Ecto.UUID.cast(id)

      assert %Order{} = Repo.get(Order, id)
      assert %User{data: %User.Data{balance: 980}} = Repo.get(User, user_id)
    end

    test "returns {:error, :products_already_purchased} if the user already purchased the product" do
      user_id = "user_id"
      product_id = "product_id"

      Repo.insert!(%User{user_id: user_id, data: %User.Data{product_ids: [product_id]}})

      assert {:error, :products_already_purchased} = Order.create(user_id, [product_id])
    end

    test "returns {:error, :products_not_found} if a given items is an empty list" do
      assert {:error, :products_not_found} = Order.create("user_id", [])
    end

    test "returns {:error, :products_not_found} if one of the given items does not exist" do
      assert {:error, :products_not_found} = Order.create("user_id", ["inexisting_product"])
    end

    test "returns {:error, :insufficient_balance} if the user does not have enough balance to purchase a product" do
      user_id = "user_id"
      Repo.insert!(%User{user_id: user_id, data: %User.Data{balance: 1}})

      product_id = "product_id"
      Repo.insert!(%Product{id: product_id, name: "Product", price: 10})

      assert {:error, :insufficient_balance} = Order.create(user_id, [product_id])
    end
  end
end
