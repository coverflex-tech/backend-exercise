defmodule Integration.Backend.Users.ManagerTest do
  use Backend.DataCase, async: true

  describe "get/1" do
    test "should return a user"
    test "should fail if user doesn't exist"
  end

  describe "add/1" do
    test "should succeed"
    test "should add a user"
    test "should fail if user_id is empty"
    test "should fail if balance is negative"
  end

  describe "order/3" do
    test "should succeed if valid"
    test "should add an order"
    test "should update the user data"
    test "should fail if user does not have sufficient ballance"
    test "should fail if user has previously bought the products"
  end
end
