defmodule Benefits.ProductsTest do
  use Benefits.DataCase

  import Benefits.ProductsFixtures

  alias Benefits.Products
  alias Benefits.Products.Product

  describe "products" do
    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{price: 10.5, name: "Product"}

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.price == 10.5
      assert product.name == "Product"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(%{price: nil, name: nil})
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end
  end
end
