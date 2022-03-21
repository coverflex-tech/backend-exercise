defmodule Backend.Users.CreateTest do
  use Backend.DataCase, async: true
  use Builders

  alias Backend.Users.Create
  alias Backend.Users.Schemas.User

  describe "call/1" do
    test "when params are valid should create a user" do
      params = %{id: "new_user"}

      {:ok, %User{} = user} = Create.call(params)

      assert %User{id: "new_user"} = user
    end

    test "when params are invalid should returns a error" do
      params = %{id: nil}

      {:error, changeset} = Create.call(params)

      expected_response = %{
        id: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
