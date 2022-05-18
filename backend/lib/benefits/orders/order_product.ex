defmodule Benefits.Orders.OrderProduct do
  use Ecto.Schema

  alias Benefits.Orders.Order
  alias Benefits.Products.Product
  alias Benefits.Users.User

  schema "orders_products" do
    belongs_to :product, Product
    belongs_to :user, User, type: :string, references: :user_id
    belongs_to :order, Order

    timestamps()
  end
end
