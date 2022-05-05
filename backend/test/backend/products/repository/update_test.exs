defmodule Backend.Products.Repository.UpdateTest do
  use Backend.DataCase, async: true

  alias Backend.Products.Repository.Update

  describe "call/1" do
    test "when product doesnt exists, return an error message" do
      response = Update.call("nonexistent", %{})

      assert {:error, "Product not found"} == response
    end
  end
end
