defmodule Benefits.AccountsTest do
  use Benefits.DataCase

  alias Benefits.Accounts

  describe "users" do
    alias Benefits.Accounts.User

    @valid_attrs %{
      balance: 120.5,
      user_id: "some user_id"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "create_user/1 with valid data creates a user" do
      attrs = %{balance: 120.5, user_id: "valid_user_id"}

      assert {:ok, %User{} = user} = Accounts.create_user(attrs)
      assert user.balance == 120.5
      assert user.user_id == "valid_user_id"
    end

    test "create_user/1 with invalid balance returns error changeset" do
      invalid_attrs = %{balance: -5.7, user_id: "invalid_balance"}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end

    test "create_user/1 with invalid user_id returns error changeset" do
      invalid_attrs = %{balance: 5.7, user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end

    test "create_user/1 with duplicate user_id returns error changeset" do
      attrs = %{balance: 120.5, user_id: "duplicate_user_id"}
      assert {:ok, %User{}} = Accounts.create_user(attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(attrs)
    end

    test "get_user/1 returns the user with given user_id" do
      user = user_fixture(%{balance: 120.5, user_id: "get_user_id"})
      fetched_user = Accounts.get_user(user.user_id)
      assert fetched_user == user
      assert fetched_user.products == []
    end

    test "get_user/1 returns nil if given user_id doesn't exist" do
      assert Accounts.get_user("inexistent_user_id") == nil
    end
  end
end
