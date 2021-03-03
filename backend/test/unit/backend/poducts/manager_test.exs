defmodule Unit.Backend.Products.ManagerTest do
  use ExUnit.Case, async: true
  import Mox

  describe "get/0" do
    setup :verify_on_exit!

    test "should return all products"
  end

  describe "get/1" do
    setup :verify_on_exit!

    test "should return a product by id"
    test "should fail if product doesn't exist"
  end
end
