defmodule Benefits.Orders.OrderProduct do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}

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
