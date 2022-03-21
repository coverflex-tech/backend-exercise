defmodule Backend.Products.Get do
 alias Backend.Products.Schemas.Product 
  alias Backend.Repo

  @spec call(%{id: String.t()}) :: Product.t() | any()
  def call(%{id: product_id}) do 
    Repo.get(Product, product_id)
  end
end
