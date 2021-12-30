defmodule Coverflex.Benefits.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price, :integer
    field :product_id, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:product_id, :name, :price])
    |> validate_required([:product_id, :name, :price])
    |> unique_constraint(:product_id)
  end
end
