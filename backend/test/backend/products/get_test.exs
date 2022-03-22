defmodule Backend.Products.GetTest do
  use Backend.DataCase, async: true
  use Builders

  alias Backend.Products.Get
  alias Backend.Products.Schemas.Product

  describe "call/1" do
    test "should return a Product given a valid ID" do
      create_product(id: "netflix")

      assert %Product{id: "netflix"} = Get.call(%{id: "netflix"})
    end

    test "should return a nil given a invalid ID" do
      assert :not_found == Get.call(%{id: "netflix"})
    end
  end
end
