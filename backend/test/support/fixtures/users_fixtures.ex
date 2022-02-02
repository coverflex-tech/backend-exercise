defmodule Backend.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        user_id: "test-user-id",
        balance: 50_000
      })
      |> Backend.Users.create_user()

    user
  end
end
