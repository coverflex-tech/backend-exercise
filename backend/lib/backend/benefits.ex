defmodule Backend.Benefits do
  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Benefits.Product

  def list_products do
    Repo.all(Product)
  end

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end
end
