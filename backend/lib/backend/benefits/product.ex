defmodule Backend.Benefits.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "products" do
    field :name, :string
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    # To avoid floating-point issues, we represent prices in the DB as cents
    |> cast(%{attrs | price: attrs.price * 100}, [:id, :name, :price])
    |> validate_required([:id, :name, :price])
    |> unique_constraint(:name)
  end
end
