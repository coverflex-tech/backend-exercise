defmodule Benefits.Products.Queries do
  alias Benefits.Products.Product
  alias Benefits.Repo

  @spec all_products :: [Product.t()]
  @doc """
  Retrieves all products.
  """
  def all_products, do: Repo.all(Product)
end
