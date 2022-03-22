defmodule Backend.BenefitsTest do
  use Backend.DataCase

  alias Backend.Benefits

  describe "users" do
    alias Backend.Benefits.User

    import Backend.BenefitsFixtures

    test "get_or_create_user/1 should get an existing user by username" do
      user = user_fixture()
      {:ok, returned_user} = Benefits.get_or_create_user(%{username: user.username})
      assert returned_user == user
    end

    test "get_or_create_user/1 should create an user when it doesn't exist" do
      {:ok, created_user} = Benefits.get_or_create_user(%{username: "foo"})
      assert %User{balance: 50000, username: "foo"} = created_user
    end
  end

  describe "products" do
    alias Backend.Benefits.Product

    import Backend.BenefitsFixtures

    @invalid_attrs %{name: nil, price: nil, string_id: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Benefits.list_products() == [product]
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name", price: 42, string_id: "some string_id"}

      assert {:ok, %Product{} = product} = Benefits.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.price == 42
      assert product.string_id == "some string_id"
    end

    test "create_product/1 should not create duplicated string_ids" do
      valid_attrs = %{name: "some name", price: 42, string_id: "some string_id"}

      assert {:ok, %Product{}} = Benefits.create_product(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Benefits.create_product(valid_attrs)
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Benefits.create_product(@invalid_attrs)
    end
  end
end
