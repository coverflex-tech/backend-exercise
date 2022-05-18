defmodule Benefits.ProductsTest do
  use Benefits.DataCase

  alias Benefits.Products

  describe "products" do
    import Benefits.ProductsFixtures

    test "sum_product_price/1 return the sum of the price of the product ids provided" do
      p1 = product_fixture(%{price: 100})
      p2 = product_fixture(%{price: 200.10})
      p3 = product_fixture(%{price: 20.99})

      assert Products.sum_product_price([p1.id, p2.id, p3.id]) == Decimal.new("321.09")
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end
  end
end
