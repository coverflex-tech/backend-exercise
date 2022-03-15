defmodule BenefitsTest do
  use Benefits.DataCase, async: true

  alias Benefits.User

  describe "get_or_create_user/1" do
    setup do
      existing_user = insert!(:user)
      insert!(:wallet, user_id: existing_user.id, amount: Money.new(5000))

      {:ok, existing_user: existing_user}
    end

    test "gets an existing user", ctx do
      username = ctx.existing_user.username

      {:ok, %User{username: ^username}} = Benefits.get_or_create_user(username)

      assert %User{username: ^username} = Repo.get_by(User, username: username)
    end

    test "creates a new user if none is found by the given username" do
      username = "Jane Doe"

      refute Repo.get_by(User, username: username)

      assert {:ok, %User{username: ^username}} = Benefits.get_or_create_user(username)

      assert %User{username: ^username} = Repo.get_by(User, username: username)
    end
  end

  describe "list_bought_products_ids/1" do
    setup do
      existing_user = insert!(:user)
      insert!(:wallet, user_id: existing_user.id, amount: Money.new(5000))

      {:ok, existing_user: existing_user}
    end

    test "returns the ids of the products already bought", ctx do
      order = insert!(:order, user_id: ctx.existing_user.id)

      {:ok, bought_product_ids} = Benefits.list_bought_products_ids(ctx.existing_user.id)

      expected_product_ids = MapSet.new(order.products, & &1.id)
      returned_product_ids = MapSet.new(bought_product_ids)

      assert MapSet.equal?(expected_product_ids, returned_product_ids)
    end
  end

  describe "list_products/1" do
    setup do
      products =
        for _i <- 1..10 do
          insert!(:product)
        end

      {:ok, products: products}
    end

    test "list all products", ctx do
      assert {:ok, products} = Benefits.list_products()

      assert products
             |> MapSet.new()
             |> MapSet.equal?(MapSet.new(ctx.products))
    end
  end
end
