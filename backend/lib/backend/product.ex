defmodule Backend.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "products" do
    field :name, :string
    field :price, :integer
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:id, :name, :price])
    |> validate_required([:id, :name, :price])
  end
end
