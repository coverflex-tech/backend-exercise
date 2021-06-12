defmodule Coverflex.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field(:total, :integer, default: 0)
    belongs_to(:user, Coverflex.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order |> cast(attrs, [])
  end

  @doc false
  def update_changeset(order, attrs) do
    order
    |> cast(attrs, [:total])
    |> check_constraint(:total, name: :total_must_be_greater_than_or_equal_zero)
    |> validate_required([:total])
  end
end
