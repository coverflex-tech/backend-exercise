defmodule Backend.Benefits.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Benefits.User
  alias Backend.Benefits.Products.Product

  schema "orders" do
    field :total_value, :integer

    belongs_to :user, User
    many_to_many :products, Product, join_through: "ordered_products"

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_value])
    |> validate_required([:total_value])
    |> put_assoc(:products, attrs.products)
    |> put_assoc(:user, attrs.user)
    |> validate_length(:products, min: 1)
  end
end
