defmodule Backend.ProductTest do
  use Backend.DataCase, async: true
  alias Backend.{Product, Repo}

  describe "list/0" do
    test "returns a list of the existing products in the database" do
      Repo.insert!(%Product{id: "product_a", name: "Product A", price: 10})
      Repo.insert!(%Product{id: "product_b", name: "Product B", price: 20})

      assert [%Product{id: "product_a"}, %Product{id: "product_b"}] = Product.list()
    end

    test "returns an empty list if there are no products in the database" do
      assert [] = Product.list()
    end
  end
end
