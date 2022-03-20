defmodule BenefitsTest do
  use Benefits.DataCase, async: true

  alias Benefits.{User, Wallet}

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

  describe "create_order/1" do
    setup do
      user = insert!(:user)
      wallet = insert!(:wallet, user_id: user.id, amount: 10_000)
      product = insert!(:product, price: wallet.amount * 2)

      {:ok, product: product, user: user, wallet: wallet}
    end

    test "fails if the user doesn't exist", ctx do
      input = build(:create_order_input, user_id: "some username", items: [ctx.product.id])
      {:error, :user_not_found} = Benefits.create_order(input)
    end

    test "fails if the user's balance isn't enough", ctx do
      input = build(:create_order_input, user_id: ctx.user.username, items: [ctx.product.id])

      assert {:error, :insufficient_balance} = Benefits.create_order(input)
    end

    test "fails if there's a product already purchased" do
      user = insert!(:user)
      order = insert!(:order, user_id: user.id)
      product = insert!(:product)
      insert!(:order_product, order_id: order.id, product_id: product.id)

      insert!(:wallet, user_id: user.id, amount: Money.add(product.price, Money.new(10_000)))

      input = build(:create_order_input, user_id: user.username, items: [product.id])
      assert {:error, :products_already_purchased} = Benefits.create_order(input)
    end

    test "fails if a product is not found", ctx do
      Repo.delete(ctx.product)

      input = build(:create_order_input, user_id: ctx.user.username, items: [1])

      assert {:error, :products_not_found} = Benefits.create_order(input)
    end

    test "debits correctly from wallet" do
      user = insert!(:user)

      products = for i <- 1..10, do: insert!(:product, price: i * 1000)

      total_price =
        Enum.reduce(products, Money.new(0), fn product, acc ->
          value = Money.new(product.price)
          Money.add(value, acc)
        end)

      wallet = insert!(:wallet, user_id: user.id, amount: Money.add(total_price, Money.new(1000)))

      input =
        build(:create_order_input, user_id: user.username, items: Enum.map(products, & &1.id))

      {:ok, _order} = Benefits.create_order(input)

      updated_wallet = Repo.get_by(Wallet, user_id: user.id)

      assert updated_wallet.amount == Money.subtract(wallet.amount, total_price)
    end
  end
end
