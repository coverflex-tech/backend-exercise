defmodule BenefitsTest do
  use Benefits.DataCase, async: true

  alias Benefits.User

  describe "get_or_create_user/1" do
    test "gets an existing user" do
      username = "John Doe"
      existing_user = insert!(:user, username: username)
      assert [%User{username: "John Doe"}] = Repo.all(User)

      {:ok, %User{username: ^username}} = Benefits.get_or_create_user(existing_user.username)

      assert [%User{username: ^username}] = Repo.all(User)
    end

    test "creates a new user if none is found by the given username" do
      assert Repo.all(User) == []

      username = "John Doe"
      {:ok, %User{username: ^username}} = Benefits.get_or_create_user(username)

      assert [%User{username: ^username}] = Repo.all(User)
    end
  end
end
