defmodule Backend.Products.Schemas.Product do
  @moduledoc """
  Definition of Product struct
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  schema "products" do
    field :name, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:id, :price, :name])
    |> validate_required([:id, :price, :name])
  end
end
