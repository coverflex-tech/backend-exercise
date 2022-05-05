defmodule Backend.Products.Repository.Update do
  alias Backend.Products.Changeset
  alias Backend.Products.Product
  alias Backend.Repo

  def call(id, params) do
    case Repo.get(Product, id) do
      %Product{} = product ->
        product
        |> Changeset.changeset(params)
        |> Repo.update()

      nil ->
        {:error, "Property not found"}

      error ->
        error
    end
  end
end
