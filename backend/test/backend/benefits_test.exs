defmodule Backend.BenefitsTest do
  use Backend.DataCase

  alias Backend.Benefits

  import Backend.BenefitsFixtures

  describe "users" do
    alias Backend.Benefits.User

    @invalid_attrs %{balance: nil, user_id: nil}

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
      assert {:error, %Ecto.Changeset{}} = Benefits.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{balance: 43, user_id: "some updated user_id"}

      assert {:ok, %User{} = user} = Benefits.update_user(user, update_attrs)
      assert user.balance == 43
      assert user.user_id == "some updated user_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Benefits.update_user(user, @invalid_attrs)
      assert user == Benefits.get_user(user.user_id)
    end
  end

  describe "products" do
    test "list_products/0 returns all products" do
      product = product_fixture()

      assert Benefits.list_products() == [product]
    end
  end
end
