defmodule Backend.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:total, :integer)
    field(:user_id, :string)

    has_many(:items, Backend.Orders.Item)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :total])
    |> validate_required([:user_id, :total])
  end
end
