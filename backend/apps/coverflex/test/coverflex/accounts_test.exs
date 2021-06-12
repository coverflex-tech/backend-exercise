defmodule Coverflex.AccountsTest do
  use Coverflex.DataCase

  alias Coverflex.Accounts

  describe "users" do
    alias Coverflex.Accounts.User

    @valid_attrs %{user_id: "some user_id"}
    @update_attrs %{user_id: "some updated user_id"}
    @invalid_attrs %{user_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{user_id: "user#{System.unique_integer([:positive])}"})
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      users = Accounts.list_users()

      assert length(users) == 4
      assert(user in users)
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by/1 returns the user with given user_id" do
      user = user_fixture()
      assert Accounts.get_user_by(:user_id, user.user_id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.user_id == "some user_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.user_id == "some updated user_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "create_user/1 validate user uniqueness" do
      Accounts.create_user(@valid_attrs)
      {:error, changeset} = Accounts.create_user(@valid_attrs)
      assert %{user_id: ["has already been taken"]} = errors_on(changeset)
    end
  end
end
