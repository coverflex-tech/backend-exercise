defmodule Benefits.Order do
  @moduledoc """
  The `Order` schema module
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Product
  alias Benefits.User

  schema "orders" do
    field(:total, :float, default: 0.00)

    belongs_to(:user, User)
    many_to_many(:products, Product, join_through: "orders_products", on_replace: :delete)

    timestamps()
  end

  @required_fields [:user_id, :total]
  @optional_fields []

  @doc false
  def changeset(%__MODULE__{} = order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:products, Map.get(attrs, :products, []))
  end
end
