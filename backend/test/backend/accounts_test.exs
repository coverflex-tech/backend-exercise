defmodule Backend.AccountsTest do
  use Backend.DataCase

  alias Backend.Accounts

  describe "users" do
    @valid_attrs %{data: %{}, user_id: "some user_id"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user(user.user_id) == user
    end

    test "get_user/1 returns new user when missing" do
      user = Accounts.get_user("new user_id")

      assert user.user_id == "new user_id"
      assert user.data.balance == 500
      assert user.data.product_ids == []
    end
  end
end
