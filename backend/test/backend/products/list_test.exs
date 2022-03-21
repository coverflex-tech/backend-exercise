defmodule Backend.Products.ListTest do
  use BackendWeb.ConnCase
  use Builders

  alias Backend.Products.Schemas.Product
  alias Backend.Products.List

  describe "list" do
    test "should return a empty list when doesn't exists a product" do
      result = List.call()

      assert [] == result
    end

    test "should return a list with existing products" do
      create_product()
      result = List.call()

      assert length(result) == 1
      assert %Product{id: "netflix"} = Enum.at(result, 0, nil)
    end
  end
end
