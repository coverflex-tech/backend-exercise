defmodule Benefits.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Orders.OrderProduct
  alias Benefits.Users.User
  alias Benefits.Products.Product

  schema "orders" do
    field :total, :decimal, default: 0

    belongs_to :user, User
    many_to_many :products, Product, join_through: OrderProduct

    field :items, {:array, :integer}, virtual: true

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :total, :items])
    |> validate_required([:user_id, :total, :items])
    |> validate_length(:items, min: 1)
  end
end
