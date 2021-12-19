defmodule Benefits.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Benefits.Users` context.
  """

  @doc """
  Generate a unique User username.
  """
  def unique_username, do: "User #{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: 120.5,
        username: unique_username()
      })
      |> Benefits.Users.create_user()

    user
  end
end
