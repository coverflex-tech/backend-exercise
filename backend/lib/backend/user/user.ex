defmodule Benefits.User do
  @moduledoc """
  The `User` schema module.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Order
  alias Benefits.Product

  schema "users" do
    field(:username, :string)
    field(:balance, :float, default: 0.0)

    many_to_many(:products, Product, join_through: "users_products", on_replace: :delete)
    has_many(:orders, Order)

    timestamps()
  end

  @required_fields [:username]
  @optional_fields [:balance]

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
    |> put_assoc(:products, Map.get(attrs, :products, []))
  end
end
