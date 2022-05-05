defmodule Backend.Users.Repository.UpdateTest do
  use Backend.DataCase, async: true

  alias Backend.Users.Repository.Update

  describe "call/1" do
    test "when user doesnt exists, return an error message" do
      response = Update.call("nonexistent", %{})

      assert {:error, "User not found"} == response
    end
  end
end
