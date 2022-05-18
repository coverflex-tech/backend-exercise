defmodule Benefits.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Orders.{Order, OrderProduct}
  alias Benefits.Products.Product

  schema "users" do
    field :username, :string
    field :balance, :decimal, default: Decimal.new("500")

    has_many :orders, Order
    many_to_many :products, Product, join_through: OrderProduct

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end
end
