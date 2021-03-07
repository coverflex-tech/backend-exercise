defmodule Unit.BackendWeb.UsersControllerTest do
  use ExUnit.Case, async: true
  import Mox

  describe "get" do
    setup :verify_on_exit!

    test "should return a user by id"
  end

  describe "order" do
    setup :verify_on_exit!

    test "should succeed if valid"
    test "should fail if products don't exist"
    test "should fail if user does not have sufficient balance"
    test "should fail if user has previously bought the products"
  end
end
