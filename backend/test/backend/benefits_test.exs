defmodule Backend.BenefitsTest do
  use Backend.DataCase

  alias Backend.Benefits
  alias Backend.Accounts

  @product_attrs %{id: "netflix", name: "Netflix", price: 42}
  @product_expensive %{id: "spotify", name: "Spotify", price: 52}
  @user_attrs %{user_id: "user", data: %{balance: 50, product_ids: []}}

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
    @order_invalid_product %{"items" => ["vodafone"], "user_id" => "user"}
    @order_all_products %{"items" => ["vodafone", "netflix"], "user_id" => "user"}

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Benefits.create_order(@order_attrs)
      assert order.data == %{items: ["netflix"], total: 42}
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {
               :error,
               %Ecto.Changeset{errors: [title: {"products_not_found", []}]}
             } = Benefits.create_order(@order_invalid_product)
    end

    test "create_order/1 with valid and invalid data returns error changeset" do
      assert {
               :error,
               %Ecto.Changeset{errors: [title: {"products_not_found", []}]}
             } = Benefits.create_order(@order_all_products)
    end
  end

  defp create_user(_) do
    user = user_fixture()
    {:ok, user: user}
  end

  defp create_products(_) do
    product = product_fixture()
    expensive = product_fixture(@product_expensive)

    {:ok, products: [product, expensive]}
  end
end
