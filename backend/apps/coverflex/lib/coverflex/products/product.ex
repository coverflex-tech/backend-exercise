defmodule Coverflex.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field(:name, :string)
    field(:price, :integer)

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price])
    |> check_constraint(:price, name: :price_must_be_greater_than_or_equal_zero)
    |> validate_required([:name, :price])
  end
end
