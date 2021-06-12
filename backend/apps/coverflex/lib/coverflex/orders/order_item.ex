defmodule Coverflex.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "order_items" do
    belongs_to(:order, Coverflex.Orders.Order)
    belongs_to(:product, Coverflex.Products.Product)

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [])
    |> validate_required([])
  end
end
