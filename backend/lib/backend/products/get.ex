defmodule Backend.Products.Get do
  @moduledoc """
  Module to get a Product givin a ID
  """
  alias Backend.Products.Schemas.Product
  alias Backend.Repo

  @spec call(%{id: String.t()}) :: Product.t() | any()
  def call(%{id: product_id}) do
    case Repo.get(Product, product_id) do
      %Product{} = product -> product
      nil -> :not_found
    end
  end
end
