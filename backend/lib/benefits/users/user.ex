defmodule Benefits.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Orders.{Order, OrderProduct}
  alias Benefits.Products.Product

  @primary_key {:user_id, :string, autogenerate: false}

  schema "users" do
    field :balance, :decimal, default: Decimal.new("500")

    has_many :orders, Order, foreign_key: :user_id
    many_to_many :products, Product, join_through: OrderProduct, join_keys: [user_id: :user_id, product_id: :id]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :balance])
    |> validate_required([:user_id])
    |> validate_number(:balance, greater_than: 0, message: "insufficient_balance")
    |> unique_constraint(:user_id)
  end
end
