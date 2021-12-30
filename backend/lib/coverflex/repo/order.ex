defmodule Coverflex.Benefits.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :total, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total])
    |> validate_required([:total])
  end
end
