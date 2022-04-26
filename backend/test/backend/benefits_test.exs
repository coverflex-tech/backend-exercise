defmodule Backend.BenefitsTest do
  use Backend.DataCase

  alias Backend.Benefits

  import Backend.BenefitsFixtures

  describe "users" do
    alias Backend.Benefits.User

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Benefits.get_user(user.user_id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{balance: 42, user_id: "some user_id"}

      assert {:ok, %User{} = user} = Benefits.create_user(valid_attrs)
      assert user.balance == 42
      assert user.user_id == "some user_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Benefits.create_user(%{balance: nil, user_id: nil})
    end
  end

  describe "products" do
    test "list_products/0 returns all products" do
      product = product_fixture()

      assert Benefits.list_products() == [product]
    end
  end

  describe "orders" do
    alias Backend.Benefits.Order

    test "create_order/1 with valid data creates an order" do
      valid_attrs = %{"items" => [], "user_id" => user_fixture().user_id}

      assert {:ok, %Order{} = _order} = Benefits.create_order(valid_attrs)
    end

    test "create_order/1 with invalid data returns error changeset" do
      invalid_attrs = %{"items" => ["non-existent benefit"], "user_id" => user_fixture().user_id}

      assert {:error, %Ecto.Changeset{}} = Benefits.create_order(invalid_attrs)
    end
  end
end
