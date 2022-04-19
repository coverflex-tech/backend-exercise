defmodule Backend.BenefitsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Benefits` context.
  """

  @doc """
  Generate a unique user user_id.
  """
  def unique_user_user_id, do: "some user_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: 42,
        user_id: unique_user_user_id()
      })
      |> Backend.Benefits.create_user()

    user
  end
end
