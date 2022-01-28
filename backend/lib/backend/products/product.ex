defmodule Backend.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "products" do
    field(:name, :string)
    field(:price, :integer)

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:id, :name, :price])
    |> validate_required([:id, :name, :price])
    |> unique_constraint(:id)
  end
end
