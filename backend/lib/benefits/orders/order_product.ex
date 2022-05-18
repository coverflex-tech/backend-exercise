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

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :order_id, :product_id])
    |> validate_required([:user_id, :order_id, :product_id])
    |> unique_constraint([:user_id, :product_id], message: "products_already_purchased")
    |> foreign_key_constraint(:product_id, message: "products_not_found")
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:user_id)
    |> exclusion_constraint(:user_id,
      name: :unique_user_id_per_order_id,
      message: "only one user is allowed per order"
    )
  end
end
