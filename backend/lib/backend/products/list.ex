defmodule Backend.Products.List do
  @moduledoc """
  Module reponsible to list all Products from catalog
  """
  alias Backend.Products.Schemas.Product
  alias Backend.Repo

  @spec call() :: [Product.t(), ...]
  def call() do
    Repo.all(Product)
  end
end
