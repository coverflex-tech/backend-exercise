defmodule Benefits.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Benefits.Products` context.
  """

  @doc """
  Generate a unique Product name.
  """
  def unique_name, do: "Product #{System.unique_integer([:positive])}"

  @doc """
  Generates a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        price: 5.0,
        name: unique_name()
      })
      |> Benefits.Products.create_product()

    product
  end
end
