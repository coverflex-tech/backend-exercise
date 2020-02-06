defmodule Backend.BenefitsTest do
  use Backend.DataCase

  alias Backend.Benefits
  alias Backend.Accounts
  alias Backend.Accounts.User

  @product_attrs %{id: "netflix", name: "Netflix", price: 21}
  @used_product_attrs %{id: "amazon-prime", name: "Amazon Prime", price: 23}
  @product_expensive %{id: "spotify", name: "Spotify", price: 52}
  @user_attrs %{user_id: "user", data: %{balance: 50, product_ids: ["amazon-prime"]}}

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(@product_attrs)
      |> Benefits.create_product()

    product
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Accounts.create_user()

    user
  end

  describe "products" do
    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Benefits.list_products() == [product]
    end
  end

  describe "orders" do
    setup [:create_user, :create_products]
    alias Backend.Benefits.Order

    @order_attrs %{"items" => ["netflix"], "user_id" => "user"}
    @only_invalid_product %{"items" => ["vodafone"], "user_id" => "user"}
    @with_invalid_products %{"items" => ["vodafone", "netflix"], "user_id" => "user"}
    @with_used_product %{"items" => ["amazon-prime", "netflix"], "user_id" => "user"}
    @with_expensive_product %{"items" => ["spotify"], "user_id" => "user"}

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Benefits.create_order(@order_attrs)
      assert order.data == %{items: ["netflix"], total: 21}

      user = Repo.get!(User, order.user_id)
      assert user.data == %{"product_ids" => ["netflix"], "balance" => 29}
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {
               :error,
               %Ecto.Changeset{errors: [title: {"products_not_found", []}]}
             } = Benefits.create_order(@only_invalid_product)
    end

    test "create_order/1 with valid and invalid data returns error changeset" do
      assert {
               :error,
               %Ecto.Changeset{errors: [title: {"products_not_found", []}]}
             } = Benefits.create_order(@with_invalid_products)
    end

    test "create_order/1 with used product returns error changeset" do
      assert {
               :error,
               %Ecto.Changeset{errors: [title: {"products_already_purchased", []}]}
             } = Benefits.create_order(@with_used_product)
    end

    test "create_order/1 with expensive product returns error changeset" do
      assert {
               :error,
               %Ecto.Changeset{errors: [title: {"insufficient_balance", []}]}
             } = Benefits.create_order(@with_expensive_product)
    end
  end

  defp create_user(_) do
    user = user_fixture()
    {:ok, user: user}
  end

  defp create_products(_) do
    product = product_fixture()
    expensive = product_fixture(@product_expensive)
    used = product_fixture(@used_product_attrs)

    {:ok, products: [product, expensive, used]}
  end
end
