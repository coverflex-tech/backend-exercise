defmodule Benefits.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Benefits.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        codename: "some codename",
        name: "some name",
        price: "120.5"
      })
      |> Benefits.Products.create_product()

    product
  end
end
