defmodule Backend.Products.Repository.Get do
  alias Backend.Products.Product
  alias Backend.Repo

  def call(id, requested_relationships \\ []) do
    case Repo.get(Product, id) do
      {:ok, product} -> {:ok, Repo.preload(product, requested_relationships)}
      nil -> {:error, "Product not found"}
      error -> error
    end
  end
end
