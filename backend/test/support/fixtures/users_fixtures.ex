defmodule Benefits.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Benefits.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: "some username"
      })
      |> Benefits.Users.create_user()

    user
  end
end
