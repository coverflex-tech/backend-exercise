defmodule Benefits.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :codename, :string
    field :name, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :codename, :price])
    |> validate_required([:name, :codename, :price])
  end
end
