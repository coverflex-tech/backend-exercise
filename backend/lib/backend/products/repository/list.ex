defmodule Backend.Products.Repository.List do
  alias Backend.Products.Product
  alias Backend.Repo

  def call, do: {:ok, Repo.all(Product)}
end
