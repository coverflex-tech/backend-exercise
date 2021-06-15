defmodule Coverflex.AccountsTest do
  use Coverflex.DataCase

  alias Coverflex.Accounts

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{user_id: "user#{System.unique_integer([:positive])}"})
      |> Accounts.create_user()

    user
  end

  describe "users" do
    alias Coverflex.Accounts.User

    @valid_attrs %{user_id: "some user_id"}
    @update_attrs %{user_id: "some updated user_id"}
    @invalid_attrs %{user_id: nil}

    test "list_users/0 returns all users" do
      assert length(Accounts.list_users()) == 0
      user_fixture()
      assert length(Accounts.list_users()) == 1
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

    test "create_user_with_account/1 with valid data" do
      {:ok, user} = Accounts.create_user_with_account(@valid_attrs)

      assert user.account.id
    end

    test "create_user_with_account/1 with invalid data" do
      assert {:error, :user, changeset, _operations_executed} =
               Accounts.create_user_with_account(@invalid_attrs)

      assert %{user_id: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "user_accounts" do
    alias Coverflex.Accounts.UserAccount

    @valid_attrs %{balance: 42}
    @update_attrs %{balance: 43}
    @invalid_attrs %{balance: nil}

    def user_account_fixture(attrs \\ %{}) do
      attrs = Map.put_new(attrs, :balance, 0)
      user = user_fixture()

      {:ok, user_account} =
        attrs
        |> Accounts.create_user_account(user)

      user_account
    end

    test "list_user_accounts/0 returns all user_accounts" do
      user_account = user_account_fixture()
      assert Accounts.list_user_accounts() |> Repo.preload([:user]) == [user_account]
    end

    test "get_user_account!/1 returns the user_account with given id" do
      user_account = user_account_fixture()
      assert Accounts.get_user_account!(user_account.id) |> Repo.preload([:user]) == user_account
    end

    test "create_user_account/1 with valid data creates a user_account" do
      user = user_fixture()

      assert {:ok, %UserAccount{} = user_account} =
               Accounts.create_user_account(@valid_attrs, user)

      assert user_account.balance == 42
    end

    test "create_user_account/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_account(@invalid_attrs, user)
    end

    test "create_user_account/1 with balance less than zero" do
      user = user_fixture()
      {:error, changeset} = Accounts.create_user_account(%{balance: -42}, user)
      assert %{balance: ["balance must be greater than or equal zero"]} = errors_on(changeset)
    end

    test "update_user_account/2 with valid data updates the user_account" do
      user_account = user_account_fixture()

      assert {:ok, %UserAccount{} = user_account} =
               Accounts.update_user_account(user_account, @update_attrs)

      assert user_account.balance == 43
    end

    test "update_user_account/2 with invalid data returns error changeset" do
      user_account = user_account_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user_account(user_account, @invalid_attrs)

      assert user_account == Accounts.get_user_account!(user_account.id) |> Repo.preload([:user])
    end

    test "delete_user_account/1 deletes the user_account" do
      user_account = user_account_fixture()
      assert {:ok, %UserAccount{}} = Accounts.delete_user_account(user_account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_account!(user_account.id) end
    end

    test "change_user_account/1 returns a user_account changeset" do
      user_account = user_account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_account(user_account)
    end
  end
end
