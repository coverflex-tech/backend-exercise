defmodule Benefits.Products.QueriesTest do
  use Benefits.DataCase, async: true

  import Benefits.Factory

  alias Benefits.Products.Queries

  describe "all_products/0" do
    test "returns empty list" do
      assert [] == Queries.all_products()
    end

    test "returns all products" do
      products = insert_list(3, :product)
      assert returned_products = Queries.all_products()
      assert length(returned_products) == length(products)
    end
  end

  describe "get_products/1" do
    setup do
      product_ids = 3 |> insert_list(:product) |> Enum.map(& &1.id)
      %{product_ids: product_ids}
    end

    test "returns {:ok, products} selecting products by id", ctx do
      product_ids = Enum.take_random(ctx.product_ids, 2)
      assert {:ok, products} = Queries.get_products(product_ids)
      assert length(products) == length(product_ids)
    end

    test "returns {:error, :products_not_found} when there are no results" do
      product_ids = [Ecto.UUID.autogenerate()]
      assert {:error, :products_not_found} == Queries.get_products(product_ids)
    end
  end
end
