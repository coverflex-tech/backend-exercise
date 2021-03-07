defmodule Backend.Products.Product do
  @moduledoc """
  Product model
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

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
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> unique_constraint(:id)
  end
end
