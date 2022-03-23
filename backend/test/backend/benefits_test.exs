defmodule Backend.BenefitsTest do
  use Backend.DataCase

  alias Backend.Benefits
  alias Backend.Benefits.{Order, User}
  alias Backend.Benefits.Products.Product

  import Backend.BenefitsFixtures

  describe "users" do
    test "get_or_create_user/1 should get an existing user by username" do
      user = user_fixture()
      {:ok, returned_user} = Benefits.get_or_create_user(%{username: user.username})
      assert returned_user == user
    end

    test "get_or_create_user/1 should create an user when it doesn't exist" do
      {:ok, created_user} = Benefits.get_or_create_user(%{username: "foo"})
      assert %User{balance: 50_000, username: "foo"} = created_user
    end
  end

  describe "products" do
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

  describe "orders" do
    test "create_order/1 with valid data creates a order" do
      product_fixture(%{string_id: "netflix", name: "Netflix", price: 7542})
      valid_attrs = %{items: ["netflix"], user_id: "foo"}

      assert {:ok,
              %Order{
                total_value: 7542,
                products: [%Product{string_id: "netflix"}],
                user: %User{username: "foo"}
              }} = Benefits.create_order(valid_attrs)
    end

    test "create_order/1 with inexistent product returns error" do
      attrs = %{items: ["foo"], user_id: "bar"}
      assert {:error, :products_not_found} = Benefits.create_order(attrs)
    end

    test "create_order/1 when user already purchased product returns error" do
      product_fixture(%{string_id: "netflix", name: "Netflix", price: 7542})
      attrs = %{items: ["netflix"], user_id: "foo"}
      {:ok, _order} = Benefits.create_order(attrs)

      assert {:error, :products_already_purchased} = Benefits.create_order(attrs)
    end

    test "create_order/1 without items returns error changeset" do
      invalid_attrs = %{items: [], user_id: "foo"}
      assert {:error, %Ecto.Changeset{}} = Benefits.create_order(invalid_attrs)
    end
  end
end
