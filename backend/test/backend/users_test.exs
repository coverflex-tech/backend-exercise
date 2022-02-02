defmodule Backend.UsersTest do
  use Backend.DataCase

  alias Backend.Users

  describe "users" do
    alias Backend.Users.User

    import Backend.UsersFixtures

    @invalid_attrs %{balance: nil, user_id: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given user_id" do
      user = user_fixture()
      assert Users.get_user!(user.user_id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{balance: 50_000, user_id: "test-user-id"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.balance == 50_000
      assert user.user_id == "test-user-id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{balance: 50_100, user_id: "some-updated-username"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.balance == 50_100
      assert user.user_id == "some-updated-username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.user_id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.user_id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
