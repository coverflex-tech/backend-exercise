defmodule Backend.Products.Repository.Get do
  alias Backend.Products.Product
  alias Backend.Repo

  def call(id) do
    case Repo.get(Product, id) do
      %Product{} = product -> {:ok, product}
      nil -> {:error, "Product not found"}
    end
  end
end
