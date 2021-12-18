defmodule Benefits.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Benefits.Users` context.
  """

  @doc """
  Generate a unique User user_id.
  """
  def unique_user_id, do: "User #{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: 120.5,
        user_id: unique_user_id()
      })
      |> Benefits.Users.create_user()

    user
  end
end
