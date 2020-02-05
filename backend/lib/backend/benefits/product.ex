defmodule Backend.Benefits.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "products" do
    field :id, :string, primary_key: true
    field :name, :string
    field :price, :integer

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:id, :name, :price])
    |> validate_required([:id, :name, :price])
    |> unique_constraint(:id)
  end
end
