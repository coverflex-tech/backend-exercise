defmodule CoverFlex.AccountsTest do
  use CoverFlex.DataCase
  alias CoverFlex.Accounts
  alias CoverFlex.Repo

  describe "users" do
    alias CoverFlex.Accounts.User

    test "create_user/1 with ID creates user" do
      assert {:ok, user} = Accounts.create_user(%{id: "alice"})
      assert user.id == "alice"
      assert user.balance == 500
    end

    test "create_user/1 without ID fails" do
      assert {:error, changeset} = Accounts.create_user()
      assert changeset.valid? == false
      assert %{id: ["can't be blank"]} = errors_on(changeset)
    end

    test "ensure_user/1 with existing ID returns existing user" do
      existing_user = Repo.insert!(%User{id: "alice"})

      assert user = Accounts.ensure_user("alice")
      assert user == existing_user
    end

    test "ensure_user/1 with ne ID returns new user" do
      existing_user = Repo.insert!(%User{id: "alice"})

      assert user = Accounts.ensure_user("bob")
      assert user != existing_user
      assert user.id == "bob"
      assert user.balance == 500
    end
  end
end
