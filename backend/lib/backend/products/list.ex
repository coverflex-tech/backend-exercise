defmodule Backend.Products.List do
  alias Backend.Products.Schemas.Product
  alias Backend.Repo

  @spec call() :: [Product.t(), ...]
  def call() do
    Repo.all(Product)
  end
end
