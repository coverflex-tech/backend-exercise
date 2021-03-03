defmodule Unit.Backend.Users.ManagerTest do
  use ExUnit.Case, async: true
  import Mox

  describe "get/1" do
    setup :verify_on_exit!

    test "should return a user"
    test "should fail if user doesn't exist"
  end

  describe "add/1" do
    setup :verify_on_exit!

    test "should succeed"
    test "should fail if user_id is empty"
    test "should fail if balance is negative"
  end

  describe "order/3" do
    setup :verify_on_exit!

    test "should succeed if valid"
    test "should fail if user does not have sufficient ballance"
    test "should fail if user has previously bought the products"
  end
end
