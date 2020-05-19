defmodule CoverFlex.ProductsTest do
  use CoverFlex.DataCase
  alias CoverFlex.Products
  alias CoverFlex.Repo

  describe "products" do
    alias CoverFlex.Products.Product

    test "list_products/0 returns all products" do
      assert products = Products.list_products()
      assert length(products) == 0

      Repo.insert!(%Product{id: "netflix", name: "Netflix", price: 75})
      Repo.insert!(%Product{id: "andchill", name: "&Chill", price: 100})

      assert products = Products.list_products()
      assert length(products) == 2
    end
  end

  describe "orders" do

  end
end
