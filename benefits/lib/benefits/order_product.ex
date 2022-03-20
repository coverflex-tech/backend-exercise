defmodule Benefits.OrderProduct do
  @moduledoc "The struct that represents an order's product"

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  schema "order_products" do
    field(:order_id, :integer)
    field(:product_id, :integer)
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
    |> unique_constraint(:product_id)
  end
end
