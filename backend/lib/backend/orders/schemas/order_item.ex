defmodule Backend.Orders.Schemas.OrderItem do
  @moduledoc """
  Definition of OrderItem struct
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Orders.Schemas.Order
  alias Backend.Orders.Schemas.Product

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "order_items" do
    field :product_id, :string
    belongs_to :product, Product, define_field: false

    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
    |> assoc_constraint(:product)
    |> assoc_constraint(:order)
  end
end
