defmodule Benefits.UsersTest do
  use Benefits.DataCase

  import Benefits.UsersFixtures

  alias Benefits.Users
  alias Benefits.Users.User

  describe "users" do
    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{balance: 120.5, username: "User"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.balance == 120.5
      assert user.username == "User"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(%{username: nil, balance: nil})
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end
  end
end
