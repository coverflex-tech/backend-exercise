defmodule Backend.UserTest do
  use Backend.DataCase, async: true
  alias Backend.{User, Repo}

  describe "get_or_create/1" do
    test "returns {:ok, %Backend.User{}} if an user with the give user_id exists in the database" do
      user_id = "user_id"

      Repo.insert!(%User{user_id: user_id, data: %User.Data{}})

      assert {:ok, %User{user_id: ^user_id}} = User.get_or_create(user_id)
      assert %User{user_id: ^user_id} = Repo.get(User, user_id)
    end

    test "returns {:ok, %Backend.User{}} if an user with the give user_id does not exist in the database" do
      user_id = "user_id"

      assert {:ok, %User{user_id: ^user_id}} = User.get_or_create(user_id)
      assert %User{user_id: ^user_id} = Repo.get(User, user_id)
    end
  end
end
