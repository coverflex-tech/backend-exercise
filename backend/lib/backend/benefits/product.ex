defmodule Backend.Benefits.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Benefits.{Order, User}

  schema "products" do
    field :name, :string
    field :price, :integer
    field :string_id, :string

    many_to_many :orders, Order, join_through: "ordered_products"
    many_to_many :users, User, join_through: "ordered_products"

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
