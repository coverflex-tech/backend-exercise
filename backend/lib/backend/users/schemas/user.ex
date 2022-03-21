defmodule Backend.Users.Schemas.User do
  @moduledoc """
  Definition of User struct
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Orders.Schemas.Order

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :binary_id
  schema "users" do
    field :balance, :decimal

    has_many :orders, Order
    has_many :order_items, through: [:orders, :order_items]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :balance])
    |> validate_required([:id, :balance])
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
