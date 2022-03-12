defmodule BenefitsTest do
  use Benefits.DataCase, async: true

  alias Benefits.User

  describe "get_or_create_user/1" do
    setup do
      existing_user = insert!(:user)
      insert!(:wallet, user_id: existing_user.id, amount: Money.new(5000))

      {:ok, existing_user: existing_user}
    end

    test "gets an existing user", ctx do
      username = ctx.existing_user.username

      {:ok, %User{username: ^username}} = Benefits.get_or_create_user(username)

      assert %User{username: ^username} = Repo.get_by(User, username: username)
    end

    test "creates a new user if none is found by the given username" do
      username = "Jane Doe"

      refute Repo.get_by(User, username: username)

      assert {:ok, %User{username: ^username}} = Benefits.get_or_create_user(username)
      assert %User{username: ^username} = Repo.get_by(User, username: username)
    end
  end
end
