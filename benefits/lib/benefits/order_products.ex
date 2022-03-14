defmodule Benefits.OrderProducts do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "order_products" do
    field(:order_id, Ecto.UUID)
    field(:product_id, Ecto.UUID)
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
  end
end
