defmodule Backend.Products.Repository.ListByIds do
  import Ecto.Query

  alias Backend.Products.Product
  alias Backend.Repo

  def call(products_ids) do
    Product
    |> where([product], product.id in ^products_ids)
    |> Repo.all()
  end
end
