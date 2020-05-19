defmodule CoverFlex.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias CoverFlex.Products.Order

  @primary_key {:id, :string, []}

  schema "products" do
    field :name, :string
    field :price, :integer
    many_to_many :orders, Order, join_through: "products_orders"

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:id, :name, :price])
    |> validate_required([:id, :name, :price])
  end
end
