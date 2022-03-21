defmodule Backend.Users.GetTest do
  use Backend.DataCase, async: true
  use Builders

  alias Backend.Users.Get
  alias Backend.Users.Schemas.User

  describe "call/1" do
    test "when user exists returns a user" do
      create_user(id: "frodo", balance: Decimal.new("100.00"))

      %User{} = user = Get.call("frodo")

      assert %User{id: "frodo"} = user

    end

    test "when user doesn`t exists returns :not_found" do
      assert :not_found =  Get.call("frodo")
    end
  end

end
