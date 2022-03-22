defmodule Backend.BenefitsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Benefits` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: 42,
        username: "some username"
      })
      |> Backend.Benefits.get_or_create_user()

    user
  end
end
