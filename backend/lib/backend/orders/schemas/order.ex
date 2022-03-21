defmodule Backend.Orders.Schemas.Order do
  @moduledoc """
  Definition of Order struct
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Orders.Schemas.User
  alias Backend.Orders.Schemas.OrderItem

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :total, :decimal

    field :user_id, :string
    belongs_to :user, User, define_field: false
    has_many :order_items, OrderItem, references: :id

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total, :user_id])
    |> validate_required([:total, :user_id])
    |> assoc_constraint(:user)
  end
end
