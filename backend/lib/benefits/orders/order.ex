defmodule Benefits.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Orders.OrderProduct
  alias Benefits.Users.User

  schema "orders" do
    field :total, :decimal

    belongs_to :user, User
    has_many :order_products, OrderProduct
    has_many :products, through: [:order_products, :products]

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
