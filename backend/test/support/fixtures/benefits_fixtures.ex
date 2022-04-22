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

  @doc """
  Generate a unique product name.
  """
  def unique_product_name, do: "some product name#{System.unique_integer([:positive])}"

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        id: unique_product_name(),
        name: unique_product_name(),
        price: 42
      })
      |> Backend.Benefits.create_product()

    product
  end

  @doc """
  Generate an order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{})
      |> Backend.Benefits.create_order()

    order
  end
end
