defmodule Backend.BenefitsTest do
  use Backend.DataCase

  alias Backend.Benefits

  describe "products" do
    @valid_attrs %{id: "some id", name: "some name", price: 42}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Benefits.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Benefits.list_products() == [product]
    end
  end
end
