defmodule Coverflex.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    # The total field is here to avoid aggregate every time we need to know
    # the total value of the order.
    # As a downside, we need to add more logic when add/remove order items
    field(:total, :integer, default: 0)
    belongs_to(:user, Coverflex.Accounts.User)
    has_many(:order_items, Coverflex.Orders.OrderItem)

    timestamps()
  end

  @doc false
  def changeset(order, attrs \\ %{}) do
    order |> cast(attrs, [:total])
  end

  @doc false
  def update_changeset(order, attrs) do
    order
    |> cast(attrs, [:total])
    |> check_constraint(:total, name: :total_must_be_greater_than_or_equal_zero)
    |> validate_required([:total])
  end
end
