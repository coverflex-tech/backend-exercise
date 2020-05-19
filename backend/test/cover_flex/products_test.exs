defmodule CoverFlex.ProductsTest do
  use CoverFlex.DataCase
  alias CoverFlex.Repo
  alias CoverFlex.Products
  alias CoverFlex.Products.Product

  describe "products" do
    test "list_products/0 returns all products" do
      assert products = Products.list_products()
      assert length(products) == 0

      Repo.insert!(%Product{id: "netflix", name: "Netflix", price: 75})
      Repo.insert!(%Product{id: "andchill", name: "&Chill", price: 100})

      assert products = Products.list_products()
      assert length(products) == 2
    end

    test "get_product/1 returns product or error" do
      Repo.insert!(%Product{id: "netflix", name: "Netflix", price: 75})
      assert {:ok, product} = Products.get_product("netflix")
      assert {:error, :not_found} = Products.get_product("andchill")
    end

    test "get_user_products/1 returns list of product ids" do
      Repo.insert!(%Product{id: "netflix", name: "Netflix", price: 75})
      Repo.insert!(%Product{id: "andchill", name: "&Chill", price: 100})

      assert {:ok, _order} = Products.create_order(%{user_id: "johndoe", product_ids: ["netflix", "andchill"]})
      assert Products.get_user_products("johndoe") == ["netflix", "andchill"]
    end

    test "totalize_products/1 returns the total price" do
      products = [
        %Product{id: "netflix", name: "Netflix", price: 75},
        %Product{id: "andchill", name: "&Chill", price: 100}
      ]
      assert Products.totalize_products(products) == 175
    end
  end

  describe "orders" do
    alias CoverFlex.Products.Order

    test "create_order/1 creates an order with a user and products associated" do
      Repo.insert!(%Product{id: "netflix", name: "Netflix", price: 75})
      Repo.insert!(%Product{id: "andchill", name: "&Chill", price: 100})

      assert {:ok, %Order{} = order} = Products.create_order(%{user_id: "johndoe", product_ids: ["netflix", "andchill"]})
      assert order.user.id == "johndoe"
      assert order.total == 175
    end
  end
end
