defmodule Backend.Users.GetOrCreateTest do
  use Backend.DataCase, async: true
  use Builders

  alias Backend.Users.GetOrCreate
  alias Backend.Users.Schemas.User

  describe "call/1" do
    test "when params are valid and user dont exists should create a user" do
      params = %{id: "new_user"}

      {:ok, %User{} = user} = GetOrCreate.call(params)

      assert %User{id: "new_user"} = user
    end

    test "when params are valid and user dont should return a user" do
      create_user(id: "usera", balance: Decimal.new("58.99"))
      params = %{id: "usera"}

      {:ok, user} = GetOrCreate.call(params)

      assert %User{id: "usera"} = user
      assert Decimal.eq?(user.balance, "58.99")

    end
  end
end
