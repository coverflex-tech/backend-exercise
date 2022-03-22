defmodule Backend.Benefits.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price, :integer
    field :string_id, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:string_id, :name, :price])
    |> validate_required([:string_id, :name, :price])
    |> unique_constraint(:string_id)
  end
end
