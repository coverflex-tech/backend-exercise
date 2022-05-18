defmodule Benefits.UsersTest do
  use Benefits.DataCase

  alias Benefits.Users

  describe "users" do
    alias Benefits.Users.User

    import Benefits.UsersFixtures

    @invalid_attrs %{user_id: nil}
    test "find_or_create_user/1 get or creates a user with given user_id" do
      user = Users.find_or_create_user("rafael")
      user2 = Users.find_or_create_user("rafael")

      assert user.user_id == "rafael"
      assert user.user_id == user2.user_id
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.user_id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{user_id: "some user_id"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.user_id == "some user_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end
  end
end
