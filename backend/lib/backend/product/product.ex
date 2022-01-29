defmodule Benefits.Product do
  @moduledoc """
  The `Product` schema module.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Order
  alias Benefits.User

  schema "products" do
    field(:identifier, :string)
    field(:name, :string, default: "")
    field(:price, :float, default: 0.00)

    many_to_many(:users, User, join_through: "users_products", on_replace: :delete)
    many_to_many(:orders, Order, join_through: "orders_products", on_replace: :delete)

    timestamps()
  end

  @required_fields [:identifier, :name, :price]
  @optional_fields []

  @doc false
  def changeset(%__MODULE__{} = product, attrs) do
    product
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:identifier)
    |> put_assoc(:users, Map.get(attrs, :users, []))
    |> put_assoc(:orders, Map.get(attrs, :orders, []))
  end
end
