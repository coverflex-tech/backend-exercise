defmodule Benefits.UsersTest do
  use Benefits.DataCase

  alias Benefits.Users

  describe "users" do
    alias Benefits.Users.User

    import Benefits.UsersFixtures

    @invalid_attrs %{username: nil}

    test "get_or_create_user_by_username!/1 get or creates a user with given username" do
      user = Users.get_or_create_user_by_username!("rafael")
      user2 = Users.get_or_create_user_by_username!("rafael")

      assert user.username == "rafael"
      assert user.id == user2.id
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{username: "some username"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "some updated username"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
