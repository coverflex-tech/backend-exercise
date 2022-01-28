defmodule Backend.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        id: "some_product_#{Enum.random(1..10000)}",
        name: "some name",
        price: 4200
      })
      |> Backend.Products.create_product()

    product
  end
end
