defmodule Backend.BenefitsTest do
  use Backend.DataCase

  alias Backend.Benefits

  describe "users" do
    alias Backend.Benefits.User

    import Backend.BenefitsFixtures

    test "get_or_create_user/1 should get an existing user by username" do
      user = user_fixture()
      {:ok, returned_user} = Benefits.get_or_create_user(%{username: user.username})
      assert returned_user == user
    end

    test "get_or_create_user/1 should create an user when it doesn't exist" do
      {:ok, created_user} = Benefits.get_or_create_user(%{username: "foo"})
      assert %User{balance: 50000, username: "foo"} = created_user
    end
  end
end
