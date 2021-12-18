defmodule Benefits.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Benefits.Products` context.
  """

  @doc """
  Generates a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        price: 120.5,
        name: "Product"
      })
      |> Benefits.Products.create_product()

    product
  end
end
