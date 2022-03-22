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

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        price: 42,
        string_id: "some string_id"
      })
      |> Backend.Benefits.create_product()

    product
  end
end
