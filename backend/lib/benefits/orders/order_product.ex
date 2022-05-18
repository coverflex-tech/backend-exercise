defmodule Benefits.Orders.OrderProduct do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Orders.Order
  alias Benefits.Products.Product
  alias Benefits.Users.User

  schema "orders_products" do
    belongs_to :product, Product
    belongs_to :user, User, type: :string, references: :user_id
    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:order_id, :user_id, :product_id])
    |> validate_required([:order_id, :user_id, :product_id])
    |> unique_constraint(:order_id, name: :orders_products_user_id_product_id_index)
  end
end
