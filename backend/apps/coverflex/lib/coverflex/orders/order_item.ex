defmodule Coverflex.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "order_items" do
    belongs_to(:order, Coverflex.Orders.Order)
    belongs_to(:product, Coverflex.Products.Product)
    # the price is here to maintain the historical record of the price
    # even if the product price is changed
    field(:price, :integer)

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:price])
    |> validate_required([:price])
  end
end
