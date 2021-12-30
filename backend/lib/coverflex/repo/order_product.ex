defmodule Coverflex.Benefits.OrderProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_products" do

    field :order_id, :id
    field :product_id, :id

    timestamps()
  end

  @doc false
  def changeset(order_product, attrs) do
    order_product
    |> cast(attrs, [])
    |> validate_required([])
  end
end
