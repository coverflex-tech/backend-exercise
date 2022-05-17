defmodule Benefits.Orders.OrderProduct do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Orders.Order
  alias Benefits.Products.Product
  alias Benefits.Users.User

  schema "orders_products" do
    belongs_to :product, Product
    belongs_to :user, User
    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
