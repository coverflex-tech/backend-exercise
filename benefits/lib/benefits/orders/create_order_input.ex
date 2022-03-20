defmodule Benefits.Orders.CreateOrderInput do
  @moduledoc "The input used for creating a new order"

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field(:user_id, :string)
    field(:items, {:array, :integer})
  end

  def changeset(order \\ %__MODULE__{}, attrs) do
    order
    |> cast(attrs, [:user_id, :items])
    |> validate_required([:user_id, :items])
    |> validate_length(:items, min: 1)
  end
end
